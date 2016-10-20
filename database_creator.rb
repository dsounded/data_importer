module DatabaseCreator
  def self.create!
    DB.create_table? :borrowers do
      String :borrower_id, primary_key: true
      String :short_name
      Float :long_name
      String :address_1
      String :address_2
      String :address_3
      String :city
      String :state
      String :zip
      String :tax_id
      String :naics_code
      Int :credit_score
    end

    DB.create_table? :relationship do
      String :relationship_id, primary_key: true
      String :name
    end

    DB.create_table? :relationship_borrowers do
      foreign_key :relationship_id, :relationship, type: 'varchar(255)'
      foreign_key :borrower_id, :borrowers, type: 'varchar(255)'
    end

    DB.alter_table(:relationship_borrowers) do
      add_unique_constraint [:relationship_id, :borrower_id]
    end

    DB.create_table? :note_details do
      String :note_id, primary_key: true
      foreign_key :relationship_id, :relationship, type: 'varchar(255)'
      Decimal :balance, size: [16, 8]
      Decimal :original_amount, size: [16, 8]
      Date :original_date
      Date :maturity_date
      Float :interest_rate
      String :risk_rating
    end
  end
end
