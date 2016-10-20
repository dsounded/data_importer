require_relative 'parsers/csv_parser'
require_relative 'parsers/txt_parser'

module FileStrategy
  NEW_LINE = "\n".freeze
  BLANK = ''
  CSV = '.csv'.freeze
  TXT = '.txt'.freeze

  def self.execute(file)
    extension = File.extname(file.sub!(NEW_LINE, BLANK))

    case extension
    when CSV then CSVParser.parse_and_import!(file)
    when TXT then
      puts 'Input TXT type: 1 - fixed width, 0 - tab-delim' 
      type = gets
      type.to_i.zero? ? TXTParser.parse_and_import_tab!(file) : TXTParser.parse_and_import!(file)
    end
  end
end
