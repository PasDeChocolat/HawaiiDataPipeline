module DataIO
  require 'csv'
  class << self

    def csv_from_dataset dataset, path, opts={}
      keys = dataset.first.keys
      CSV.open(path, "a", opts) do |csv|
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

    def json_from_dataset dataset, path
      File.open(path, "a") do |f|
        f.write(dataset.to_json)
      end
    end

  end
end