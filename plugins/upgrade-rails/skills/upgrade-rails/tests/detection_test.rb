require "tmpdir"
require "fileutils"
require "open3"
require_relative "../references/ombulabs/detection-scripts/scan_patterns"

def check(message, condition)
  abort "FAIL: #{message}" unless condition
end

Dir.mktmpdir("upgrade-rails-test") do |root|
  write = lambda do |path, content|
    file = File.join(root, path)
    FileUtils.mkdir_p(File.dirname(file))
    File.write(file, content)
  end
  write.call("Gemfile.lock", "GEM\n  specs:\n    rails (7.1.6)\n")
  write.call("app/models/record.rb", <<~RUBY)
    serialize :old_json, JSON
    serialize :old_array, Array
    serialize :new_json, coder: JSON
    serialize :new_array, type: Array, coder: YAML
    serialize :default_coder
    serialize(
      :multiline,
      JSON
    )
    query_constraints :tenant_id, :id
    belongs_to :account, query_constraints: [:tenant_id, :account_id]
    belongs_to :owner, :query_constraints => [:tenant_id, :owner_id]
    ActiveRecord::Base.connection_pool
    ActiveRecord::Base.connection_handler
    ActiveRecord::Base.connection
  RUBY
  write.call("app/services/notify.rb", "NotificationJob.perform_later(record)\n")
  write.call("test/test_helper.rb", "self.fixture_path = 'test/fixtures'\n")
  results, = run_scan(patterns_file_for("7.2"), root)
  by_id = results.to_h { |result| [result.fetch(:variable), result] }
  lines = ->(id) { by_id.fetch(id).fetch(:hits).map { |hit| hit[1] }.sort }
  check("only positional serialize arguments are flagged", lines.call("SERIALIZE_SYNTAX") == [1, 2, 8])
  check("model query_constraints is distinct from the association option", lines.call("QUERY_CONSTRAINTS") == [11, 12])
  check("connection_pool and connection_handler are not connection calls", lines.call("AR_CONNECTION") == [15])
  check("fixture_path is a removal on 7.2", by_id.fetch("FIXTURE_PATH").fetch(:kind) == "breaking")
  job = by_id.fetch("TRANSACTION_JOBS")
  check("async job is a behavioral review candidate", job.fetch(:bucket) == "behavior_change" && job.fetch(:hits).size == 1)
  check("job guidance preserves async execution", job.fetch(:fix).include?("Keep asynchronous jobs asynchronous") && !job.fetch(:fix).include?("perform_now"))
  check("job guidance checks the adapter", job.fetch(:explanation).include?("queue adapter"))

  write.call("config/application.rb", <<~RUBY)
    config.cache_store = :redis_cache_store
    config.active_job.queue_adapter = :sidekiq
    config.assets.enabled = true
  RUBY
  write.call("config/database.yml", "production:\n  pool: 5\n")
  write.call("db/migrate/create_accounts.rb", <<~RUBY)
    t.integer :balance, unsigned: true
    t.unsigned_float :legacy_balance
  RUBY
  results81, = run_scan(patterns_file_for("8.1"), root)
  by_id81 = results81.to_h { |result| [result.fetch(:variable), result] }
  check("configured Sidekiq adapter is detected", by_id81.fetch("SIDEKIQ_ADAPTER").fetch(:hits).size == 1)
  check("Sidekiq adapter is deprecated rather than removed", by_id81.fetch("SIDEKIQ_ADAPTER").fetch(:kind) == "deprecation")
  check("unsigned integers are distinct from removed floating-point helpers", by_id81.fetch("MYSQL_UNSIGNED").fetch(:hits).map { |hit| hit[1] } == [2])
  check("retaining Redis, Sprockets, or pool does not produce a rule", results81.select { |result| !result.fetch(:hits).empty? }.map { |result| result.fetch(:variable) }.sort == %w[MYSQL_UNSIGNED SIDEKIQ_ADAPTER])

  all_results = available_versions.flat_map { |version| run_scan(patterns_file_for(version), root).first }
  check("every retained rule has an official source", all_results.all? { |result| Array(result[:sources]).any? && result[:sources].all? { |url| url.start_with?("https://github.com/rails/rails/blob/") } })
  check("every retained rule has a verification date", all_results.all? { |result| result[:verified_at] == "2026-10-23" })
  check("missing paths remain visible", by_id.values.any? { |result| status_of(result) == "unscanned" })

  script = File.expand_path("../references/ombulabs/detection-scripts/scan_patterns.rb", __dir__)
  json, status = Open3.capture2e("ruby", script, "--root", root, "--target", "7.2", "--format", "json")
  check("CLI JSON command succeeds", status.success?)
  findings = JSON.parse(json).fetch("findings")
  check("JSON output exposes evidence", findings.all? { |result| !result.fetch("sources").empty? && result.fetch("verified_at") })
  markdown, status = Open3.capture2e("ruby", script, "--root", root, "--target", "7.2")
  check("Markdown output exposes evidence without assigning deployment timing", status.success? && markdown.include?("Source: https://github.com/rails/rails/blob/") && !markdown.include?("Fix before bump"))
  unsupported, status = Open3.capture2e("ruby", script, "--root", root, "--target", "9.9")
  check("unsupported targets fail with an explanation", !status.success? && unsupported.include?("no version guide ends"))
end

puts "Detection regressions passed."
