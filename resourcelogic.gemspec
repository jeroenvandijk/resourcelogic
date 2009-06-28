# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{resourcelogic}
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = %q{2009-06-28}
  s.email = %q{bjohnson@binarylogic.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.rdoc",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "init.rb",
     "lib/resourcelogic.rb",
     "lib/resourcelogic/accessors.rb",
     "lib/resourcelogic/action_options.rb",
     "lib/resourcelogic/actions.rb",
     "lib/resourcelogic/aliases.rb",
     "lib/resourcelogic/base.rb",
     "lib/resourcelogic/child.rb",
     "lib/resourcelogic/context.rb",
     "lib/resourcelogic/context_options.rb",
     "lib/resourcelogic/failable_action_options.rb",
     "lib/resourcelogic/parent.rb",
     "lib/resourcelogic/response_collector.rb",
     "lib/resourcelogic/scope.rb",
     "lib/resourcelogic/self.rb",
     "lib/resourcelogic/sibling.rb",
     "lib/resourcelogic/singleton.rb",
     "lib/resourcelogic/sub_views.rb",
     "lib/resourcelogic/urligence.rb"
  ]
  s.homepage = %q{http://github.com/binarylogic/resourcelogic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{resourcelogic}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Removes the need to namespace controllers by adding context and relative url functions among other things.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
