class StocksController < ApplicationController
  def search

    if(params[:stock].present?)
      # @stock = Stock.new_lookup(params[:stock])
      @stock = Stock.new(name: 'Alphabet', ticker: "GOOG", last_price: 1300)
      if @stock
        respond_to do |format|
          format.js {render partial: 'users/result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js {render partial: 'users/result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js {render partial: 'users/result' }
      end
    end
  end
end