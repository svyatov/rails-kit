require "fileutils"
require "json"
require "open3"
require "tmpdir"

validator = File.expand_path("validate.rb", __dir__)
icon = File.expand_path("../.claude-plugin/icon.png", __dir__)
cases = {
  "multiple skills in one plugin" => [nil, nil],
  "empty kit" => [->(root) { FileUtils.rm_r("#{root}/skills") }, "No skills found"],
  "Claude source" => [->(root) {
    path = "#{root}/.claude-plugin/marketplace.json"
    catalog = JSON.parse(File.read(path))
    catalog["plugins"][0]["source"] = "./missing"
    File.write(path, JSON.generate(catalog))
  }, "incorrect Claude source"],
  "implicit invocation" => [->(root) {
    File.write("#{root}/skills/audit-one/agents/openai.yaml", "policy:\n  allow_implicit_invocation: true\n")
  }, "must disable implicit invocation"],
  "model invocation" => [->(root) {
    path = "#{root}/skills/audit-one/SKILL.md"
    File.write(path, File.read(path).sub("disable-model-invocation: true", "disable-model-invocation: false"))
  }, "must disable model invocation"],
  "user invocation" => [->(root) {
    path = "#{root}/skills/audit-one/SKILL.md"
    File.write(path, File.read(path).sub("disable-model-invocation: true", "disable-model-invocation: true\nuser-invocable: false"))
  }, "must remain explicitly callable"],
  "Codex source" => [->(root) {
    path = "#{root}/.agents/plugins/marketplace.json"
    catalog = JSON.parse(File.read(path))
    catalog["plugins"][0]["source"]["path"] = "./missing"
    File.write(path, JSON.generate(catalog))
  }, "incorrect Codex source"],
  "README description" => [->(root) {
    path = "#{root}/README.md"
    File.write(path, File.read(path).sub("| Audit one. |", "| Wrong description. |"))
  }, "README entry differs"],
  "contribution links" => [->(root) {
    File.write("#{root}/CONTRIBUTING.md", "[Missing](skills/missing/SKILL.md)\n")
  }, "broken link"],
  "misplaced skill" => [->(root) {
    FileUtils.mkdir_p("#{root}/skills/nested/extra")
    File.write("#{root}/skills/nested/extra/SKILL.md", "Unexpected skill")
  }, "Unregistered or misplaced skills"]
}

cases.each do |name, (mutate, expected_error)|
  Dir.mktmpdir("rails-kit-validator") do |root|
    write = lambda do |path, content|
      FileUtils.mkdir_p(File.dirname("#{root}/#{path}"))
      File.write("#{root}/#{path}", content)
    end
    write.call(".claude-plugin/plugin.json", JSON.generate(name: "rails-kit", description: "Rails kit.", version: "1.0.0"))
    FileUtils.cp(icon, "#{root}/.claude-plugin/icon.png")
    write.call(".claude-plugin/marketplace.json", JSON.generate(name: "rails-kit", plugins: [{name: "rails-kit", description: "Rails kit.", source: "./"}]))
    write.call(".agents/plugins/marketplace.json", JSON.generate(name: "rails-kit", plugins: [{name: "rails-kit", source: {source: "local", path: "./"}, policy: {installation: "AVAILABLE", authentication: "ON_INSTALL"}}]))
    write.call("AGENTS.md", "Fixture\n")
    write.call("CONTRIBUTING.md", "Fixture\n")
    write.call("CHANGELOG.md", "Fixture\n")
    readme = "Rails kit.\n"
    %w[one two].each do |suffix|
      skill = "audit-#{suffix}"
      description = "Audit #{suffix}."
      write.call("skills/#{skill}/SKILL.md", "---\nname: #{skill}\ndescription: #{description}\ndisable-model-invocation: true\n---\n\nAudit.\n")
      write.call("skills/#{skill}/agents/openai.yaml", "policy:\n  allow_implicit_invocation: false\n")
      readme << "| [#{skill}](skills/#{skill}/SKILL.md) | #{description} |\n"
    end
    write.call("README.md", readme)
    mutate&.call(root)
    output, status = Open3.capture2e("ruby", validator, root)
    passed = expected_error ? !status.success? && output.include?(expected_error) : status.success? && output.include?("2 explicitly callable skills")
    abort "FAIL: #{name}\n#{output}" unless passed
  end
end

puts "Validator regressions passed (#{cases.size} cases)."
