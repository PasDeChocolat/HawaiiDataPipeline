#!/usr/bin/env ruby -w
require 'net/https'
require 'fileutils'
require 'json'
require 'set'
require 'yaml'

# require local libraries (from ./lib)
$:.unshift File.dirname(__FILE__)+"/lib"
require 'pipeline_dataset'
require 'catalog_item'

module HDPipeline
  STATE_API_URL = "data.hawaii.gov"
  STATE_CATALOG_ID = "8igt-zydr"
  CITY_API_URL  = "data.honolulu.gov"

  CLIENT_ENV = "development"
  APP_ROOT = File.expand_path(File.dirname(__FILE__))
  WEEK_IN_MINUTES = 60 * 24 * 7
  CACHE_MINUTES = WEEK_IN_MINUTES * 4
  CACHE_ROOT = APP_ROOT + "/tmp/cache"
  CONFIG_ROOT = APP_ROOT + "/config"
  
  class Client
    include PipelineDataset
    attr_reader :config
    
    class << self
      def slurp_config
        raw_config = File.read "#{CONFIG_ROOT}/config.yml"
        YAML.load(raw_config)[CLIENT_ENV]
      end
    end
    
    def initialize(opts={})
      @user_config = self.class.slurp_config || {}
      @config = {}
      @config[:gov] = opts[:gov] || :state
      @config[:app_token] = opts[:app_token]
      @config[:app_token] ||= @user_config[:socrata] ? @user_config[:socrata][:app_token] : nil
      @config[:app_token] ||= "K6rLY8NBK0Hgm8QQybFmwIUQw"
      puts "API requests will use app_token: #{@config[:app_token]}"
      FileUtils.mkdir_p CACHE_ROOT
    end

    def set_dataset_type city_or_state
      @config[:gov] = city_or_state
    end

    def dataset_type
      @config[:gov]
    end

    def response_for! url
      # Create our request
      use_ssl = url.start_with? "https://"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = use_ssl
      if use_ssl
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("X-App-Token", @config[:app_token])
      response = http.request request
      { body: response.body,
        code: response.code }
    end

    def cache_name_for url
      url.gsub(/http[s]?:\/\//, "")
        .gsub(/[;,\/&$?=]/, "_")
    end
    
    def response_for url
      name = cache_name_for url
      response = read_fragment(name)
      return response if response

      response = response_for! url
      return nil if response[:code] != "200"
      
      write_fragment(name, response[:body])
    end
    
    def read_fragment name
      cache_file = "#{CACHE_ROOT}/#{name}.cache"
      now = Time.now
      if File.file?(cache_file)
        if CACHE_MINUTES > 0
          (current_age = (now - File.mtime(cache_file)).to_i / 60)
          puts "Fragment for '#{name}' is #{current_age} minutes old."
          return false if (current_age > CACHE_MINUTES)
        end
        return File.read(cache_file)
      end
      false
    end
    
    def write_fragment name, buf
      cache_file = "#{CACHE_ROOT}/#{name}.cache"
      cache_file += ".json" if name.end_with? ".json"
      f = File.new(cache_file, "w+")
      f.write(buf)
      f.close
      puts "Fragment written for '#{name}'"
      buf
    end

    def clear_cache!
      dataset_size = @dataset_catalog ? @dataset_catalog.size : 0
      @dataset_catalog = {}
      puts "Cache of #{dataset_size} catalog#{dataset_size == 1 ? '' : 's'} cleared."
    end

    def is_state_data?
      @config[:gov] == :state
    end

    def api_url
      is_state_data? ? STATE_API_URL : CITY_API_URL
    end
    
    # Paging supported, see docs here:
    # http://dev.socrata.com/docs/queries
    #
    # keep_in_mem if you'd like to return all the data as an array.
    # This means it will be kept in memory, so it can be returned.
    def data_for index_or_id, opts={}
      opts = {
        offset: 0,
        keep_in_mem: true,
        from_cache: true,
        soda_query: nil
      }.merge(opts)
      offset   = opts[:offset]
      all_data = opts[:keep_in_mem] ? [] : nil
      
      id = index_or_id
      id = PipelineDataset.resource_id_at datasets, index_or_id if index_or_id.is_a? Integer

      while true do
        url = "http://#{api_url}/resource/#{id}.json?$limit=1000&$offset=#{offset}"
        url += opts[:soda_query] if !opts[:soda_query].to_s.empty?
        puts "url is: #{url}"
        r = opts[:from_cache] ? response_for(url) : response_for!(url)
        d = JSON.parse(r)
        all_data += d if opts[:keep_in_mem]
        break if d.size < 1000
        offset += 1
      end

      all_data
    end
    alias_method :data_at, :data_for

    # Retrieve all the data from an API end-point, but just throw it
    # into cache files.  It is not accumulated in memory.
    def run_data_for index_or_id, opts={}
      opts.merge!({ keep_in_mem: false }) # override!

      id = index_or_id
      id = PipelineDataset.resource_id_at datasets, index_or_id if index_or_id.is_a? Integer

      data_for id, opts
    end
    alias_method :run_data_at, :run_data_for

    def list_item_at index_or_id
      d = PipelineDataset.catalog_item_at datasets, index_or_id
      puts "No dataset for that index or ID." if d.nil?
      d
    end
    alias_method :list_item_for, :list_item_at

    def describe index_or_id
      item = list_item_at index_or_id
      pp item
      nil
    end

    def catalog_at index_or_id
      list_item_at index_or_id
    end

    def catalog_search search_str
      PipelineDataset.select_catalog datasets, :any, search_str
    end
    alias_method :search_catalog, :catalog_search

    def catalog_with_name search_str
      PipelineDataset.select_catalog datasets, :name, search_str
    end
    
    def datasets
      return @dataset_catalog[dataset_type] unless @dataset_catalog.nil? || @dataset_catalog[dataset_type].nil?

      if is_state_data?
        # If state, use shiney, new catalog of datasets
        d = data_for STATE_CATALOG_ID, soda_query: "&$where=type='datasets'"
        items = d.map do |item|
          PipelineDataset.format_catalog_item_hash( 
            CatalogItem.name(item), 
            CatalogItem.id(item), 
            metadata: item
          )
        end
      else
        # Use old page-scraping technique for other catalogs:
        items = scraped_datasets
      end

      @dataset_catalog ||= {}
      @dataset_catalog[dataset_type] = PipelineDataset.sort_catalog( items )
    end

    def scraped_datasets
      puts "Generating scaped dataset catalog..."
      links = Set.new
      page = 1
      while true do
        puts "Looking for datasets on page #: #{page}"
        url = "https://#{api_url}/browse/embed?limitTo=datasets&q=&view_type=table&page=#{page}"
        puts "url is: #{url}"
        response = response_for url
        break if response.nil?
        
        new_links = response.scan(/href="(?:http[s]?:\/\/.*?)?(\/[^\/]*?\/[^\/]*?)\/(.{4,4}-.{4,4})"/)
        break if new_links.empty?

        hashes = new_links.map do |link|
          PipelineDataset.format_catalog_item_hash( link[0], link[1] )
        end
        links.merge Set.new(hashes)
        puts "... #{links.size} unique datasets found... (still searching)"
        page += 1
      end
      puts "Dataset catalog generation complete, found #{links.size} datasets."
      PipelineDataset.sort_catalog( links )
    end

    def list_datasets search_str=nil
      list = search_str.nil? ? datasets : catalog_search(search_str)
      list.each do |d|
        PipelineDataset.print_catalog_item d
      end
      nil
    end
    alias_method :list, :list_datasets

  end
end

HDP=HDPipeline # Create module alias