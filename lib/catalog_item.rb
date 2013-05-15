class CatalogItem
  attr_accessor :catalog_item

  def initialize _catalog_item
     @catalog_item = _catalog_item
  end  

  def describe
    pp @catalog_item
    nil;
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