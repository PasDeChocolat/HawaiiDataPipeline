module DataIO
  require 'csv'
  class << self

    def csv_from_dataset dataset, path
      keys = dataset.first.keys
      CSV.open(path, "ab") do |csv|
        csv << keys
        dataset.each do |row|
          a = []
          keys.each do |k|
            a << row[k]
          end
          csv << a
        end
      end
    end

  end
end