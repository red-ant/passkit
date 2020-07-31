require "spec"
require "../src/passkit"

def create_pass
  PassKit::Pass.from_json(File.read("spec/fixtures/generic_pass_valid.json"))
end

def create_manifest
  PassKit::Manifest.new(create_pass)
end
