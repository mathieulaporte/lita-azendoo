Gem::Specification.new do |spec|
  spec.name          = "lita-azendoo"
  spec.version       = "0.1.0"
  spec.authors       = ["Mathieu Laporte"]
  spec.email         = ["mlaporte@azendoo.com"]
  spec.description   = "Lita adaptater for Azendoo"
  spec.summary       = "Lita adaptater for Azendoo"
  spec.homepage      = "https://github.com/mathieulaporte/lita-azendoo"
  spec.license       = "wtfpl"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "faye"
  spec.add_development_dependency "eventmachine"
  spec.add_development_dependency "em-synchrony"
end
