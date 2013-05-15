class CatalogItem
  attr_accessor :catalog_item

  def initialize _catalog_item
     @catalog_item = _catalog_item
  end  

  def describe
    pp @catalog_item
    nil;
  end

  def columns
    metadata["properties"]
  end

  def column name_or_id
    if name_or_id.is_a? String
      cols = columns.select { |p| p["fieldName"] == name_or_id || p["name"] == name_or_id }
    elsif name_or_id.is_a? Integer
      cols = columns.select { |p| p["id"] == name_or_id }
    end

    return nil if cols && cols.empty?
    cols
  end

  def column_names
    columns.map { |p| p["fieldName"] }
  end

  def column_field_names
    columns.map { |p| p["name"] }
  end


  # Meta-programming ahead.  Enjoy!  Or, shut eyes firmly... your choice.
  #
  # This allows you to do things like this:
  #  > i = client.catalog_at 0
  #
  #  > i.keys  
  #   => [:name, :id, :metadata, :index]
  #
  #  > i.name
  #   => "1. USA.gov Short Links"
  #
  #  > i.id
  #   => "wzeq-n5pg"
  #
  #  # The trailing "nil" just suppresses echoing of output.
  #  > i.each {|key, value| puts "#{key} is #{value}" };nil
  #   name is 1. USA.gov Short Links
  #   id is wzeq-n5pg
  #   metadata is {"system_id"=>"wzeq-n5pg"...
  #   index is 0
  #   => nil
  #
  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @catalog_item.has_key?(name)
      @catalog_item[name]
    elsif @catalog_item.class.method_defined? name
      @catalog_item.send(name, *args, &blk)
    else
      super
    end
  end
end