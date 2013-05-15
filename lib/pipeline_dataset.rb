module PipelineDataset
  class << self

    def sort_catalog catalog
      sorted = catalog.to_a.sort_by { |ds| ds[:name] }
      return sorted unless sorted.first[:index].nil?

      sorted.each_with_index.map { |x,i| x[:index] = i; x }
    end

    def catalog_item_at catalog, index_or_id
      if index_or_id.is_a? Integer
        catalog.select { |d| d[:index] == index_or_id }.first
      elsif index_or_id.is_a? String
        catalog.select { |d| d[:id] == index_or_id }.first
      end
    end

    def resource_id_at catalog, index
      r = catalog_item_at catalog, index
      r && r[:id]
    end

    def print_catalog_item item
      puts "#{item[:index]}) Name: #{item[:name]}  ID: #{item[:id]}"
    end

    # Defines the structure of the catalog items.
    def format_catalog_item_hash name, id, opts={}
      opts = {
        metadata: nil
      }.merge(opts)
      h = { name: name, id: id }
      h[:metadata] = opts[:metadata] unless opts[:metadata].nil?
      h
    end
    
  end
end
