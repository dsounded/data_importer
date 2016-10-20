require 'fixedwidth'
require 'active_support/all'
require 'csv'

require_relative '../persist'

module TXTParser
  TAB_DELIMITER = "\t".freeze
  QUOTE_CHAR = '|'.freeze
  START_LINE = 7
  RELATION_ID_ROW = 12
  BORROW_ID_ROW = 0
  NOTE_ID_ROW = 20

  def self.parse_and_import!(path)
    line_number = 1
    hash = []

    Fixedwidth.parse(file: path,
                     start: '1, 35,66, 107,148,189,230,271,274,284,294,301,342,377,431,476,497,513,538,619,682',
                     stop: '34, 65,106,147,188,229,270,273,283,293,300,341,376,380,475,481,512,521,546,626,20',
                     header: 'borrower_id,short_name,long_name,address_1,address_2,address_3,city,state,zip,tax_id,naics_code,name,relationship_id,credit_score,note_id,balance,original_amount,original_date,maturity_date,interest_rate,risk_rating',
                     delimiter: ',') do |line|
      line_number += 1
      next true if line_number <= START_LINE

      hash << line.to_hash
    end

    Persist.save(hash.map { |row| row.slice(:borrower_id, :short_name, :long_name, :address_1, :address_2, :address_3, :city,
                                             :state, :zip, :tax_id, :naics_code) },
                 hash.map { |row| row.slice(:name, :relationship_id) },
                 hash.map { |row| row.slice(:relationship_id, :borrower_id) },
                 hash.map { |row| row.slice(:note_id, :balance, :original_amount, :original_date, :maturity_date, :interest_rate, :risk_rating) })
  end

  def self.parse_and_import_tab!(path)
    borrowers = []
    relations = []
    relation_borrowers = []
    notes = []

    rows = CSV.read(path, { col_sep: TAB_DELIMITER, quote_char: QUOTE_CHAR })
    rows.drop(START_LINE).each do |row|
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
