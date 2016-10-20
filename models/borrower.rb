require 'sequel'

require_relative '../config'

class Borrower < Sequel::Model
  set_primary_key :borrower_id
end
