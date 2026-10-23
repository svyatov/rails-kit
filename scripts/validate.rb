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

manifest_path = ".claude-plugin/plugin.json"
manifest = JSON.parse(File.read(manifest_path))
name = manifest.fetch("name")
description = manifest.fetch("description")
check(name == "rails-kit", "#{manifest_path}: expected rails-kit plugin")
check(description.is_a?(String) && (1..1024).cover?(description.size), "#{manifest_path}: invalid description")
check(manifest.fetch("version").match?(/\A\d+\.\d+\.\d+\z/), "#{manifest_path}: invalid version")
check(Dir.glob("**/.claude-plugin/plugin.json").sort == [manifest_path], "Unexpected plugin manifests")

icon = manifest.fetch("icon")
check(File.file?(icon), "#{name}: missing plugin icon")
header = File.binread(icon, 24)
check(header.start_with?("\x89PNG\r\n\x1a\n".b) && header.bytesize == 24, "#{icon}: invalid PNG header")
width, height = header.byteslice(16, 8).unpack("N2")
check(width == height && (512..2048).cover?(width), "#{icon}: must be square and 512 to 2048 pixels")
check(File.size(icon) < 2 * 1024 * 1024, "#{icon}: must be under 2 MB")

claude = JSON.parse(File.read(".claude-plugin/marketplace.json"))
codex = JSON.parse(File.read(".agents/plugins/marketplace.json"))
[claude, codex].each do |catalog|
  check(catalog.fetch("name") == name, "Unexpected marketplace name")
  check(catalog.fetch("plugins").map { |entry| entry.fetch("name") } == [name], "Catalog must contain only rails-kit")
end
claude_entry = claude.fetch("plugins").first
codex_entry = codex.fetch("plugins").first
check(claude_entry.fetch("source") == "./", "#{name}: incorrect Claude source")
check(codex_entry.fetch("source") == {"source" => "local", "path" => "./"}, "#{name}: incorrect Codex source")
check(claude_entry.fetch("description") == description, "#{name}: catalog description differs")
check(codex_entry.fetch("policy") == {"installation" => "AVAILABLE", "authentication" => "ON_INSTALL"}, "#{name}: incorrect installation policy")

renames = claude["renames"]
check(renames.is_a?(Hash) && !renames.empty?, "#{name}: rename history required")
renames.each_key do |former|
  target = former
  visited = []
  while renames.key?(target)
    check(!visited.include?(target), "renames.#{former}: rename cycle")
    visited << target
    target = renames.fetch(target)
    check(target.nil? || target.is_a?(String), "renames.#{former}: invalid target")
  end
  check(target.nil? || target == name, "renames.#{former}: chain does not resolve")
end

readme = File.read("README.md")
check(readme.include?(description), "#{name}: README description differs")
skills = Dir.glob("skills/*/SKILL.md").sort
check(!skills.empty?, "No skills found")
check(Dir.glob("**/SKILL.md").sort == skills, "Unregistered or misplaced skills found")
check(Dir.glob("skills/*").select { |path| File.directory?(path) }.sort == skills.map { |path| File.dirname(path) }, "Skill directory missing SKILL.md")

skills.each do |skill_path|
  name = File.basename(File.dirname(skill_path))
  content = File.read(skill_path)
  header = content.match(/\A---\n(.*?)\n---\n/m)
  check(header, "#{skill_path}: missing frontmatter")
  metadata = yaml(skill_path, header[1])
  check(metadata.is_a?(Hash), "#{skill_path}: frontmatter must be a map")
  check(metadata.fetch("name") == name && name.size <= 64 && name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/), "#{skill_path}: invalid name")
  description = metadata.fetch("description")
  check(description.is_a?(String) && (1..1024).cover?(description.size), "#{skill_path}: invalid description")
  if metadata.key?("compatibility")
    compatibility = metadata["compatibility"]
    check(compatibility.is_a?(String) && (1..500).cover?(compatibility.size), "#{skill_path}: invalid compatibility")
  end
  check(metadata["disable-model-invocation"] == true, "#{skill_path}: must disable model invocation")
  check(metadata.fetch("user-invocable", true) == true, "#{skill_path}: must remain explicitly callable")
  policy_path = "skills/#{name}/agents/openai.yaml"
  policy = yaml(policy_path).fetch("policy")
  check(policy["allow_implicit_invocation"] == false, "#{policy_path}: must disable implicit invocation")
  check(readme.include?("| [#{name}](#{skill_path}) | #{description} |"), "#{name}: README entry differs")
end

Dir.glob("skills/**/*.json").each { |path| JSON.parse(File.read(path)) }
Dir.glob("{skills,docs}/**/*.md").concat(Dir.glob("*.md")).each do |path|
  File.read(path).scan(/\[[^\]]*\]\(([^)]+)\)/).flatten.each do |target|
    target = target.split(/\s+["']/).first
    next if target.match?(/\A(?:[a-z][a-z0-9+.-]*:|#)/i)
    local = URI::DEFAULT_PARSER.unescape(target.split("#").first)
    check(File.exist?(File.expand_path(local, File.dirname(path))), "#{path}: broken link #{target}")
  end
end

puts "Validated rails-kit with #{skills.size} explicitly callable skills, both catalogs, frontmatter, descriptions, and local Markdown references."
