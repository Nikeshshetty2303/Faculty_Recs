class CsvImportService
    require 'csv'
    def initialize(file)
        @file = file
        @count =0
    end

    def import
        @count =0
        CSV.foreach(@file.path, headers: true) do |row|
            CreditQuestion.create! row.to_hash
            @count +=1
        end
    end

    def number_imported_with_last_run
        @count
    end
end