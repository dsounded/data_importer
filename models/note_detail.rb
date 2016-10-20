require 'sequel'

require_relative '../config'

class NoteDetail < Sequel::Model
  set_primary_key :note_id
end
