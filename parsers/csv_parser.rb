require 'sequel'
require 'csv'
require_relative '../persist'

require_relative '../models/borrower'
require_relative '../models/relationship'
require_relative '../models/relationship_borrower'
require_relative '../models/note_detail'

RELATION_ID_ROW = 12
BORROW_ID_ROW = 0
NOTE_ID_ROW = 20

module CSVParser
  START_LINE = 7

  def self.parse_and_import!(path, length = CSV.read(path).length)
    rows = CSV.readlines(path)[START_LINE..length]
    borrowers = []
    relations = []
    relation_borrowers = []
    notes = []

    inserts = rows.each do |row|
      borrowers << { borrower_id: row[BORROW_ID_ROW], short_name: row[1], long_name: row[2], address_1: row[3],
                     address_2: row[4], address_3: row[5], city: row[6], state: row[7], zip: row[8],
                     tax_id: row[9], naics_code: row[10], credit_score: row[13] }

      relations << { relationship_id: row[RELATION_ID_ROW], name: row[11] }
      relation_borrowers << { relationship_id: row[RELATION_ID_ROW], borrower_id: row.first } if row[RELATION_ID_ROW]
      notes << { note_id: row[NOTE_ID_ROW], relationship_id: row[RELATION_ID_ROW], balance: row[21], original_amount: row[23], original_date: row[24],
                 maturity_date: row[26], interest_rate: row[32], risk_rating: row[38] } if row[RELATION_ID_ROW]
    end

    Persist.save(borrowers, relations, relation_borrowers, notes)
  end
end
