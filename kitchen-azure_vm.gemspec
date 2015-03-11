# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/azure_vm_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-azure_vm'
  spec.version       = Kitchen::Driver::AZURE_VM_VERSION
  spec.authors       = ['Masashi Terui']
  spec.email         = ['marcy9114@gmail.com']
  spec.description   = %q{A Test Kitchen Driver for Azure Virtual Machine}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/marcy-terui/kitchen-azure_vm'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen', '>= 1.3'
  spec.add_dependency 'azure'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'tailor'
  spec.add_development_dependency 'countloc'
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rspec"
end
