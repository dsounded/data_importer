require 'sequel'

require_relative '../config'

class Relationship < Sequel::Model
  set_dataset :relationship
  set_primary_key :relationship_id
end
