# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{risbn}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Emmanuel Oga"]
  s.date = %q{2010-04-19}
  s.description = %q{Utils to handle isbns}
  s.email = %q{EmmanuelOga@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/risbn.rb",
     "lib/risbn/gdata.rb",
     "lib/risbn/nokogiri_utils.rb",
     "lib/risbn/scanner.rb",
     "lib/risbn/version.rb",
     "risbn.gemspec",
     "spec/fixtures/0072253592.xml",
     "spec/fixtures/book.xml",
     "spec/gdata_spec.rb",
     "spec/risbn_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/EmmanuelOga/risbn}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Utils to handle isbns}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/gdata_spec.rb",
     "spec/risbn_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end

