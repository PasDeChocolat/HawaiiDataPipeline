module PipelineDataset
  class << self

    def sort_catalog catalog
      sorted = catalog.to_a.sort_by { |ds| ds[:name] }
      return sorted unless sorted.first[:index].nil?

      sorted.each_with_index.map { |x,i| x[:index] = i; x }
    end

    def catalog_item_at catalog, index
      catalog.select { |d| d[:index] == index }.first
    end

    def resource_id_at catalog, index
      r = catalog_item_at catalog, index
      r && r[:id]
    end

    def print_catalog_item item
      puts "#{item[:index]}) Name: #{item[:name]}  ID: #{item[:id]}"
    end

    def format_catalog_item_hash name, id, index=nil
      h = { name: name, id: id }
      h[:index] = index unless index.nil?
      h
    end
    
  end
end
