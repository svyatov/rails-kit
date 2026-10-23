require "tmpdir"
require "fileutils"
require_relative "../references/ombulabs/detection-scripts/scan_patterns"

def fail_io(receiver, method, path, error)
  original = receiver.method(method)
  receiver.define_singleton_method(method) do |file, *args|
    raise error if file.to_s == path
    original.call(file, *args)
  end
  yield
ensure
  receiver.define_singleton_method(method, original)
end

Dir.mktmpdir("upgrade-rails-coverage") do |root|
  models = File.join(root, "app/models")
  FileUtils.mkdir_p(models)
  File.write(File.join(models, "good.rb"), "Rails.application.secrets.good\n")
  bad = File.join(models, "bad.rb")
  File.write(bad, "Rails.application.secrets.bad\n")
  entry = {"pattern" => "Rails\\.application\\.secrets", "search_paths" => ["app/models/"]}
  [
    [File, :binread, bad, Errno::EACCES.new(bad)],
    [File, :read, bad, Errno::EACCES.new(bad)],
    [File, :read, bad, Errno::ENOENT.new(bad)]
  ].each do |receiver, method, path, error|
    fail_io(receiver, method, path, error) do
      result = Scanner.new(root).scan(entry)
      abort "Read failure reported as #{status_of(result)}" unless status_of(result) == "partial"
      abort "Failed file was counted as scanned" unless result[:files_scanned] == 1
      abort "Successful findings were lost" unless result[:hits].map(&:first) == ["app/models/good.rb"]
      abort "Failed path was not exposed" unless result[:errors].any? { |e| e[:path] == "app/models/bad.rb" }
    end
  end

  locked = File.join(models, "locked")
  FileUtils.mkdir_p(locked)
  File.write(File.join(locked, "hidden.rb"), "Rails.application.secrets.hidden\n")
  fail_io(Dir, :entries, locked, Errno::EACCES.new(locked)) do
    result = Scanner.new(root).scan(entry)
    abort "Directory failure was hidden" unless status_of(result) == "partial" && result[:errors].any? { |e| e[:path] == "app/models/locked" }
  end
  failing_matcher = Class.new(Scanner) do
    def scan_content(content, pattern, exclude)
      raise ArgumentError, "forced matcher failure" if content.include?("secrets.bad")
      super
    end
  end
  result = failing_matcher.new(root).scan(entry)
  abort "Matcher failure was hidden" unless status_of(result) == "partial" && result[:errors].any? { |e| e[:error].include?("forced matcher failure") }
  broken_pattern = Object.new
  def broken_pattern.match(*)
    raise Encoding::CompatibilityError, "forced encoding failure"
  end
  begin
    Scanner.new(root).safe_match(broken_pattern, "text", 0)
    abort "Pattern matching error was swallowed"
  rescue Encoding::CompatibilityError
  end

  fail_io(File, :read, bad, Errno::EACCES.new(bad)) do
    results, roots = run_scan(patterns_file_for("7.2"), root)
    json = JSON.parse(render_json({:to => "7.2", :modular_roots => roots}, results))
    rule = json.fetch("findings").find { |finding| finding["variable_name"] == "SECRETS_REMOVED" }
    abort "JSON lost partial coverage" unless rule["status"] == "partial" && !rule.fetch("errors").empty?
    abort "JSON lost findings from partial scans" unless json.fetch("summary").fetch("patterns_fired") > 0
    markdown = render_markdown({:to => "7.2", :modular_roots => roots}, results, {})
    abort "Markdown lost coverage errors" unless markdown.include?("Partial coverage") && markdown.include?("app/models/bad.rb")
  end
  result = Scanner.new(root).scan("pattern" => "anything", "search_paths" => ["missing/"])
  abort "Missing paths are not unscanned" unless status_of(result) == "unscanned"
  result = Scanner.new(root).scan("pattern" => "not_present", "search_paths" => ["app/models/"])
  abort "Successful scan is not clean" unless status_of(result) == "clean"

  ["modules/billing", "sets/backend/payments"].each do |path|
    member = File.join(root, path)
    FileUtils.mkdir_p(File.join(member, "app/models"))
    File.write(File.join(member, "package.yml"), "enforce_privacy: true\n")
    File.write(File.join(member, "app/models/model.rb"), "Rails.application.secrets.token\n")
  end
  hits = Scanner.new(root).scan(entry).fetch(:hits).map(&:first)
  abort "Custom module roots were missed" unless ["modules/billing", "sets/backend/payments"].all? { |path| hits.include?("#{path}/app/models/model.rb") }
end

puts "Coverage error regressions passed."
