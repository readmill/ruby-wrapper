require 'time'
require 'json'

require 'readmill/model'

require 'readmill/models/book'
require 'readmill/models/user'
require 'readmill/models/period'
require 'readmill/models/reading'
require 'readmill/models/location'

require 'readmill/tokens/anonymous'

module Readmill
  def self.protocol
    'http'
  end
  
  class API
    attr_reader :options
    
    def initialize(options = {})
      @options = { :endpoint => 'api.readmill.com' }.merge(options)
      
      @options[:token] ||= Readmill::AnonymousToken.new(options[:id])
    end
    
    def books
      api, books = self, Object.new
      
      books.instance_eval do
        [:find, :match, :all, :search, :create].each do |name|
          define_singleton_method(name) do |options = {}|
            Readmill::Book.send(name, api.options.merge(options))
          end
        end
      end
      
      books
    end
    
    def users
      api, users = self, Object.new
      
      users.instance_eval do
        [:find, :current].each do |name|
          define_singleton_method(name) do |options = {}|
            Readmill::User.send(name, api.options.merge(options))
          end
        end
      end
      
      users
    end
    
    def periods
      api, periods = self, Object.new
      
      periods.instance_eval do
        [:find_by_reading_id].each do |name|
          define_singleton_method(name) do |options = {}|
            Readmill::Period.send(name, api.options.merge(options))
          end
        end
      end
      
      periods
    end
    
    def readings
      api, readings = self, Object.new
      
      readings.instance_eval do
        [:find, :all, :by_user_id, :create].each do |name|
          define_singleton_method(name) do |options = {}|
            Readmill::Reading.send(name, api.options.merge(options))
          end
        end
      end
      
      readings
    end
    
    def locations
      api, locations = self, Object.new
      
      locations.instance_eval do
        [:find_by_reading_id].each do |name|
          define_singleton_method(name) do |options = {}|
            Readmill::Location.send(name, api.options.merge(options))
          end
        end
      end
      
      locations
    end
  end
end
