

# response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:sandbox_api_key]}")
require 'httparty'
 
class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks
    validates :name, :ticker, presence: true
    def self.company_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:sandbox_api_key]}")
        if response.code == 200
          response.parsed_response['Name']
        else
          nil
        end
    end
 
    def self.new_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:sandbox_api_key]}")
        if response.code == 200 && response.parsed_response['Global Quote']
          last_price = response.parsed_response['Global Quote']['05. price']
          name = company_lookup(ticker_symbol)
          new(ticker: ticker_symbol, name: name, last_price: last_price)
        else
          nil
        end
    end
    def self.check_db(ticker_symbol)
      where(ticker: ticker_symbol).first
    end
end