# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/slack_take_turns/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-slack_take_turns"
  spec.version       = Ruboty::SlackTakeTurns::VERSION
  spec.authors       = ["oharato"]
  spec.email         = ["oharato@live.jp"]

  spec.summary       = %q{Ruboty plugin to manage a duty that members in a slack channel take turns on}
  spec.description   = %q{Ruboty plugin to manage a duty that members in a slack channel take turns on}
  spec.homepage      = "https://github.com/oharato/ruboty-slack_take_turns"
  spec.license = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 4.0"

  spec.add_development_dependency "bundler", "~> 4.0", ">= 4.0.22"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "bundler-audit", "~> 0.9"
  spec.add_development_dependency "irb", "~> 1.0"

  spec.add_dependency "ruboty", "~> 1.4", ">= 1.4.1"
  spec.add_dependency "slack-ruby-client", "~> 3.3"
  spec.add_dependency "faraday", ">= 2.14.3", "< 3"
  spec.add_dependency "i18n", "~> 1.15", ">= 1.15.2"
end
