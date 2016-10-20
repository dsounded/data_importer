require 'sequel'

DB = Sequel.connect(adapter: 'mysql2', database: 'data_import', user: ENV['db_user'], password: ENV['db_password'], host: 'localhost')
