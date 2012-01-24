require 'rubygems'
require 'active_record'

$:.unshift File.expand_path("lib")
require 'active_record_or'

gem 'minitest'
require 'minitest/autorun'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:' )
