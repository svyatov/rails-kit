require "json"
require "yaml"
require "uri"

root = File.expand_path(ARGV.fetch(0, ".."), __dir__)
Dir.chdir(root)

def check(condition, message)
  abort message unless condition
end

def yaml(path, content = File.read(path))
  YAML.safe_load(content, filename: path)
end

claude = JSON.parse(File.read(".claude-plugin/marketplace.json")).fetch("plugins")
codex = JSON.parse(File.read(".agents/plugins/marketplace.json")).fetch("plugins")
paths = Dir.glob("plugins/*/.claude-plugin/plugin.json").sort
check(!paths.empty?, "No plugin manifests found")
names = paths.map { |path| JSON.parse(File.read(path)).fetch("name") }
[names, claude.map { |entry| entry.fetch("name") }, codex.map { |entry| entry.fetch("name") }].each do |list|
  check(list.uniq == list, "Duplicate plugin name")
  check(list.sort == names.sort, "Catalog and plugin names differ")
end

readme = File.read("README.md")
expected_skills = []
paths.each do |path|
  manifest = JSON.parse(File.read(path))
  name = manifest.fetch("name")
  description = manifest.fetch("description")
  plugin_root = "plugins/#{name}"
  check(path == "#{plugin_root}/.claude-plugin/plugin.json", "#{path}: name does not match directory")
  check(manifest.fetch("version").match?(/\A\d+\.\d+\.\d+\z/), "#{path}: invalid version")
  claude_entry = claude.find { |entry| entry.fetch("name") == name }
  codex_entry = codex.find { |entry| entry.fetch("name") == name }
  check(claude_entry.fetch("source") == "./#{plugin_root}", "#{name}: incorrect Claude source")
  check(codex_entry.fetch("source") == {"source" => "local", "path" => "./#{plugin_root}"}, "#{name}: incorrect Codex source")
  check(claude_entry.fetch("description") == description, "#{name}: catalog description differs")

  skill_path = "#{plugin_root}/skills/#{name}/SKILL.md"
  expected_skills << skill_path
  content = File.read(skill_path)
  header = content.match(/\A---\n(.*?)\n---\n/m)
  check(header, "#{skill_path}: missing frontmatter")
  metadata = yaml(skill_path, header[1])
  check(metadata.is_a?(Hash), "#{skill_path}: frontmatter must be a map")
  check(metadata.fetch("name") == name && name.size <= 64 && name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/), "#{skill_path}: invalid name")
  check(description.is_a?(String) && (1..1024).cover?(description.size), "#{path}: invalid description")
  check(metadata.fetch("description") == description, "#{skill_path}: description differs from manifest")
  if metadata.key?("compatibility")
    compatibility = metadata["compatibility"]
    check(compatibility.is_a?(String) && (1..500).cover?(compatibility.size), "#{skill_path}: invalid compatibility")
  end
  check(metadata["disable-model-invocation"] == true, "#{skill_path}: must disable model invocation")
  check(metadata.fetch("user-invocable", true) == true, "#{skill_path}: must remain explicitly callable")
  policy_path = "#{plugin_root}/skills/#{name}/agents/openai.yaml"
  policy = yaml(policy_path).fetch("policy")
  check(policy["allow_implicit_invocation"] == false, "#{policy_path}: must disable implicit invocation")
  check(readme.include?("| [#{name}](#{skill_path}) | #{description} |"), "#{name}: README entry differs")
end
check(Dir.glob("plugins/**/SKILL.md").sort == expected_skills.sort, "Unregistered or misplaced skills found")

Dir.glob("{plugins,docs}/**/*.md").push("README.md", "AGENTS.md", "CHANGELOG.md").each do |path|
  File.read(path).scan(/\[[^\]]*\]\(([^)]+)\)/).flatten.each do |target|
    target = target.split(/\s+["']/).first
    next if target.match?(/\A(?:[a-z][a-z0-9+.-]*:|#)/i)
    local = URI::DEFAULT_PARSER.unescape(target.split("#").first)
    check(File.exist?(File.expand_path(local, File.dirname(path))), "#{path}: broken link #{target}")
  end
end

puts "Validated #{names.size} explicitly callable plugins, both catalogs, frontmatter, descriptions, and local Markdown references."
