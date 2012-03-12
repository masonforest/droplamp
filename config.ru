# This file is used by Rack-based servers to start the application.
if ((ENV['RACK_ENV'] || 'development') != 'development') then
	require 'sass/plugin/rack'
	use Sass::Plugin::Rack
	Sass::Plugin.options[:never_update] = true
end

require ::File.expand_path('../config/environment',  __FILE__)
run Kissr::Application
