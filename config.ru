require 'bundler'
Bundler.require

require File.expand_path('./snowbot/config/environment',  __FILE__)

run SnowBotApp
