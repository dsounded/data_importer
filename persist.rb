module Persist
  def self.save(borrowers, relations, relation_borrowers, notes)
    persisted_borrowers_ids = Borrower.map(&:borrower_id)
    persisted_relationships_ids = Relationship.map(&:relationship_id)
    persisted_relationships = RelationshipBorrower.map { |record| { relationship_id: record.relationship_id, borrower_id: record.borrower_id } }
    persisted_note_ids = NoteDetail.map(&:note_id)

    DB.transaction do
      Borrower.multi_insert(borrowers.uniq { |row| row[:borrower_id] }.reject { |row| persisted_borrowers_ids.include?(row[:borrower_id]) })
      Relationship.multi_insert(relations.uniq { |row| row[:relationship_id] }.
                                          reject { |row| persisted_relationships_ids.include?(row[:relationship_id]) || row[:relationship_id].nil? })
      RelationshipBorrower.multi_insert(relation_borrowers.uniq.reject { |row| persisted_relationships.include?(row) })
      NoteDetail.multi_insert(notes.reject { |row| persisted_note_ids.include?(row[:note_id]) || row[:note_id].nil? })
    end
  end
end
