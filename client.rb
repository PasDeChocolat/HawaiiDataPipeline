#!/usr/bin/env ruby -w
require 'net/https'
require 'fileutils'
require 'json'
require 'set'
require 'yaml'

module HDPipeline
  API_URL = "data.hawaii.gov"
  CLIENT_ENV = "development"
  APP_ROOT = File.expand_path(File.dirname(__FILE__))
  WEEK_IN_MINUTES = 60 * 24 * 7
  CACHE_MINUTES = WEEK_IN_MINUTES * 4
  CACHE_ROOT = APP_ROOT + "/tmp/cache"
  CONFIG_ROOT = APP_ROOT + "/config"
  
  class Client

    class << self
      def slurp_config
        raw_config = File.read "#{CONFIG_ROOT}/config.yml"
        YAML.load(raw_config)[CLIENT_ENV]
      end
    end
    
    def initialize(opts={})
      @user_config = self.class.slurp_config || {}
      @config = {}
      @config[:app_token] = opts[:app_token]
      @config[:app_token] ||= @user_config[:socrata] ? @user_config[:socrata][:app_token] : nil
      @config[:app_token] ||= "K6rLY8NBK0Hgm8QQybFmwIUQw"
      FileUtils.mkdir_p CACHE_ROOT
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
      puts "using app_token: #{@config[:app_token]}"
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
    
    # assumes json, http (not https)
    def get! url
      response = response_for! url
      # Check our response code
      if response && response[:code] != "200"
        raise "Error querying \"#{url.to_s}\": #{response[:body]}"
      else
        return response[:body]
      end
    end

    def get url
      name = cache_name_for url
      read_fragment(name) || write_fragment(name, get!(url))
    end

    def get_json url
      return JSON.parse(get(url))
    end

    def clear_cache!
      dataset_size = @dataset_links ? @dataset_links.size : 0
      @dataset_links = nil
      puts "Cache of #{dataset_size} dataset name#{dataset_size == 1 ? '' : 's'} cleared."
    end

    # client.views                 # returns all views, all columns
    # client.views(limit: 2)       # limits returned dataset to 2
    # client.views(cols: [:name])  # returns only the "name" kv pair, for all views
    # client.views(limit: 3, cols: [:id, :name])  # returns the "id" and "name" kv pairs, 
                                                  #   limiting to three views
    def views(opts={})
      limit = opts[:limit]
      cols = opts[:cols] || []

      url = "http://#{API_URL}/api/views"
      url += "?limit=#{limit}" if limit
      all_views = get_json url
      
      return all_views if cols.empty?

      column_names = cols.map{ |c| c.to_s }
      all_views.map do |v| 
        v.reject! { |k, v| !column_names.include?(k) }
      end
      return all_views
    end

    # Sorted by a key
    def views_sorted_by sort_thing
      views.sort_by{ |v| v[sort_thing.to_s] }
    end

    # All keys in a view
    def view_keys
      sample = views(limit: 1)
      return nil if sample.empty?
      sample.first.keys.map { |k| k.to_sym }
    end

    # List of all dataset view names
    def list_views
      views_sorted_by('name').each do |n|
        puts "#{n['name']}"
      end
      nil
    end

    # Paging supported, see docs here:
    # http://dev.socrata.com/docs/queries
    #
    # keep_in_mem if you'd like to return all the data as an array.
    # This means it will be kept in memory, so it can be returned.
    def data_for id, opts={}
      opts = {
        offset: 0,
        keep_in_mem: true
      }.merge(opts)
      offset   = opts[:offset]
      all_data = opts[:keep_in_mem] ? [] : nil
      
      while true do
        d = get_json "http://#{API_URL}/resource/#{id}.json?$limit=1000&$offset=#{offset}"
        all_data += d if opts[:keep_in_mem]
        break if d.size < 1000
        offset += 1
      end

      all_data
    end

    # Retrieve all the data from an API end-point, but just throw it
    # into cache files.  It is not accumulated in memory.
    def run_data_for id, opts={}
      opts.merge!({ keep_in_mem: false }) # override!
      data_for id, opts
    end


    def datasets
      return @dataset_links unless @dataset_links.nil?
      
      links = Set.new
      page = 0
      while true do
        puts "Looking for datasets on page #: #{page}"
        url = "https://#{API_URL}/browse/embed?limitTo=datasets&page=#{page}"
        puts "url is: #{url}"
        response = response_for url
        break if response.nil?
        
        new_links = response.scan(/href="(?:http:\/\/.*?)?(\/[^\/]*?\/[^\/]*?)\/(.{4,4}-.{4,4})"/)
        break if new_links.empty?
        
        links.merge Set.new(new_links)
        puts "... #{links.size} unique datasets found... (still searching)"
        page += 1
      end
      puts "Search complete, found #{links.size} datasets."
      @dataset_links = links
    end

    def list_datasets
      sorted_datasets.each_with_index do |d, idx|
        puts "#{idx}) Name: #{d.first}  ID: #{d[1]}"
      end
      nil
    end

    def sorted_datasets
      datasets.to_a.sort_by { |ds| ds.first }
    end
  end
end
