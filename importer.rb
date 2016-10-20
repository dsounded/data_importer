require 'sequel'

require_relative 'database_creator'
require_relative 'file_strategy'

require_relative 'config'

DatabaseCreator.create!

puts 'Please set the path to the file:'

path = gets

FileStrategy.execute(path)

puts 'All data has been successfully imported'
