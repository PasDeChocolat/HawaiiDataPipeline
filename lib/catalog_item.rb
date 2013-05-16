module CatalogItem
  class << self

    def columns item
      item = item[:metadata] if item.has_key? :metadata
      item["properties"]
    end

    def column item, name_or_id
      if name_or_id.is_a? String
        cols = columns(item).select { |p| p["fieldName"] == name_or_id || p["name"] == name_or_id }

      elsif name_or_id.is_a? Integer
        cols = columns(item).select { |p| p["id"] == name_or_id }
      end

      return nil if cols && cols.empty?
      cols 
    end

    def column_like item, name
      regex = /#{name}/i
      columns(item).select { |p| regex =~ p["fieldName"] || regex =~  p["name"] }
    end

    def column_names item
      columns(item).map { |p| p["fieldName"] }
    end

    def column_display_names item
      columns(item).map { |p| p["name"] }
    end

    def describe item
      pp item
      nil;
    end

    def index item
      item[:index]
    end

    def id item
      return item[:id] if item.has_key? :id
      item = item[:metadata] if item.has_key? :metadata
      item["id"]
    end

    def name item
      return item[:name] if item.has_key? :name
      item = item[:metadata] if item.has_key? :metadata
      item["name"]["description"]
    end

    def description item
      item = item[:metadata] if item.has_key? :metadata
      item["description"]
    end

  end
end
CI = CatalogItem  # Create alias