source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :development, :test do
  gem 'activesupport', '<=3.2.8',              :require => false
  gem 'addressable', '<2.4.0',                 :require => false
  gem 'hocon', '<0.9.0',                       :require => false
  gem 'i18n', '0.6.11',                        :require => false
  gem 'json',                                  :require => false
  gem 'metadata-json-lint',                    :require => false
  gem 'mime-types', '<2.0',                    :require => false
  gem 'nokogiri', '<1.6.0',                    :require => false
  gem 'pry',                                   :require => false
  gem 'puppet_facts',                          :require => false
  gem 'puppetlabs_spec_helper',                :require => false
  gem 'puppet-lint-absolute_classname-check',  :require => false
  gem 'puppet-lint-absolute_template_path',    :require => false
  gem 'puppet-lint-leading_zero-check',        :require => false
  gem 'puppet-lint-numericvariable',           :require => false
  gem 'puppet-lint-param-docs',                :require => false
  gem 'puppet-lint',                           :require => false
  gem 'puppet-lint-trailing_newline-check',    :require => false
  gem 'puppet-lint-unquoted_string-check',     :require => false
  gem 'puppet-lint-variable_contains_upcase',  :require => false
  gem 'rake',                                  :require => false
  gem 'retriable', '<2.0.0',                   :require => false
  gem 'rspec', '~>3.0.0',                      :require => false
  gem 'rspec-puppet', '~>2.2.0',               :require => false
  gem 'rspec-puppet-facts',                    :require => false
  gem 'rspec-puppet-utils',                    :require => false
  gem 'simplecov',                             :require => false
end

group :system_test do
  gem 'serverspec',    :require => false
  gem 'beaker',        :require => false
  if beaker_version = ENV['BEAKER_VERSION']
    gem 'beaker', *location_for(beaker_version)
  end
  if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else
    gem 'beaker-rspec',  :require => false
  end
end



if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '>=3.8.4', :require => false
end

# vim:ft=ruby
