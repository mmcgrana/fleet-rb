Gem::Specification.new do |s|
  s.name = "fleet"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark McGranaghan"]
  s.date = "2009-12-31"
  s.description = "Ruby client for FleetDB."
  s.email = "mmcgrana@gmail.com"
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE", "README.md", "lib/fleet.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/mmcgrana/fleet-rb}
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.5"
  s.summary = "Ruby client for FleetDB."
  s.add_dependency "yajl-ruby", "~> 0.6.7"
end
