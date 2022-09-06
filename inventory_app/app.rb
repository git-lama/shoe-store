# app.rb

require 'thin'
require 'sinatra/base'
require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'redis'

EventMachine.run do
  class App < Sinatra::Base

    configure do
      REDISTOGO_URL = "redis://localhost:6379/"
      uri = URI.parse(REDISTOGO_URL)
      REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end

    # Homepage

    get '/' do
      update_inventory
      fetch_inventory_data
      erb :index
    end

    # Returns inventory data as JSON response

    get '/inventory_data' do
      content_type :json
      stores_list = redis.smembers(:store)
      stores = stores_list.map do |store_name|
        data = redis.hgetall store_name
        { store_name => data }
      end

      stores.to_json
    end


    # Updates inventory data in redis db

    def update_inventory
      EM.run {
        ws = Faye::WebSocket::Client.new('ws://localhost:8080/')
        ws.on :message do |event|
          store_data = JSON.parse(event.data)
          store_name = store_data["store"]
          store_hash = {}

          if redis.smembers('store').include?(store_name)
            curr_store_data = REDIS.hgetall store_data['store']
            store_hash = curr_store_data.merge({ store_data['model'] => store_data['inventory'] })
          else
            redis.sadd :store, store_name
            store_hash = { store_data['model'] => store_data['inventory'] }
          end

          redis.mapped_hmset store_name, store_hash
        end
      }
    end

    def fetch_inventory_data
      @stores_list = redis.smembers(:store)
      @stores = @stores_list.map do |store_name|
        data = redis.hgetall store_name
        [ store_name, data ]
      end
    end

    def redis
      REDIS
    end
  end



  App.run! :port => 3000
end
