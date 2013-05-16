module PipelineDataset
  require 'catalog_item'
  class << self

    def select_catalog catalog, search_type, search_str
      if search_type == :index
        filtered = catalog.select do |d|
          (search_str.is_a?(Integer) && search_str == CatalogItem.index(d))
        end
      elsif search_type == :any
        return select_catalog(catalog, :index, search_str) if search_str.is_a?(Integer)
        filtered = catalog.select do |d|
          /#{search_str}/i =~ CatalogItem.name(d) ||
          /#{search_str}/i =~ CatalogItem.id(d) ||
          /#{search_str}/i =~ CatalogItem.description(d)
        end
      elsif catalog.first.has_key? search_type
        filtered = catalog.select do |d|
          /#{search_str}/i =~ d[search_type]
        end
      end
      
      return nil if filtered.nil? || filtered.empty?
      sort_catalog filtered
    end

    def sort_catalog catalog
      return nil if catalog.nil?
      sorted = catalog.to_a.sort_by { |d| d[:name] }
      return sorted unless sorted.first[:index].nil?

      sorted.each_with_index.map { |d,i| d[:index] = i; d }
    end

    def catalog_item_at catalog, index_or_id
      if index_or_id.is_a? Integer
        catalog.select { |d| d[:index] == index_or_id }.first
      elsif index_or_id.is_a? String
        catalog.select { |d| d[:id] == index_or_id }.first
      end
    end

    def resource_id_at catalog, index
      item = catalog_item_at catalog, index
      item && item[:id]
    end

    def print_catalog_item item
      puts "#{item[:index]}) Name: #{item[:name]}  ID: #{item[:id]}"
    end

    # Defines the structure of the catalog items.
    def format_catalog_item_hash name, id, opts={}
      opts = {
        metadata: nil
      }.merge(opts)
      d = { name: name, id: id }
      d[:metadata] = opts[:metadata] unless opts[:metadata].nil?
      d
    end
    
  end
end