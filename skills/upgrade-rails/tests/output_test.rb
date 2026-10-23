require "tmpdir"
require "fileutils"
require "open3"
require "json"

Dir.mktmpdir("upgrade-rails-output") do |root|
  script = File.expand_path("../references/ombulabs/detection-scripts/scan_patterns.rb", __dir__)
  lockfile = File.join(root, "Gemfile.lock")
  File.write(lockfile, "GEM\n  specs:\n    rails (7.1.6)\n")
  output = File.join(root, "tmp/report.md")
  FileUtils.mkdir_p(File.dirname(output))
  File.write(output, "previous report")
  stdout, stderr, status = Open3.capture3("ruby", script, "--root", root, "--target", "7.2", "--explain", "RUBY_VERSION", "--output", output)
  abort "Explanation was not written to its destination: #{stderr}" unless status.success? && stdout.empty? && File.file?(output) && File.read(output).include?("rails.gemspec")

  [
    ["--target", "9.9"],
    ["--target", "7.2", "--explain", "UNKNOWN"],
    ["--target", "7.2", "--only", "UNKNOWN"],
    ["--root", File.join(root, "missing"), "--target", "7.2"]
  ].each do |arguments|
    File.write(output, "previous report")
    _, _, status = Open3.capture3("ruby", script, "--root", root, *arguments, "--output", output)
    abort "Failed command changed the existing report: #{arguments.inspect}" if status.success? || !File.file?(output) || File.read(output) != "previous report"
  end

  source = File.join(root, "app/models/record.rb")
  FileUtils.mkdir_p(File.dirname(source))
  File.write(source, "Rails.application.secrets.token\n")
  alias_path = File.join(root, "lock-alias")
  File.symlink(lockfile, alias_path)
  patterns = File.join(root, "patterns.yml")
  File.write(patterns, "version: '7.2'\nupgrade_findings: {}\n")
  [[lockfile, []], [alias_path, []], [source, []], [patterns, ["--patterns", patterns]]].each do |destination, arguments|
    before = File.read(destination)
    _, stderr, status = Open3.capture3("ruby", script, "--root", root, "--target", "7.2", *arguments, "--output", destination)
    abort "An input file was accepted as output: #{destination}" if status.success? || !File.file?(destination) || File.read(destination) != before || !stderr.include?("input file")
  end

  stdout, stderr, status = Open3.capture3("ruby", script, "--root", root, "--target", "7.2", "--format", "json", "--output", output)
  abort "JSON report output failed: #{stderr}" unless status.success? && stdout.empty? && JSON.parse(File.read(output)).fetch("to") == "7.2"
  stdout, stderr, status = Open3.capture3("ruby", script, "--root", root, "--target", "7.2", "--explain", "RUBY_VERSION")
  abort "Explanation stdout failed: #{stderr}" unless status.success? && stdout.include?("rails.gemspec")
  abort "Temporary output files remain" unless Dir.glob(File.join(root, "tmp/.rails-pattern-*")).empty?
end

puts "Output safety regressions passed."
