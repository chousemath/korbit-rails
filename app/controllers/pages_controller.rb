class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home
    puts "PARAMS: #{params.inspect}"
    @transaction_count = params[:data] ? params[:data][:transaction_count].to_i : 50
    puts "TRANSACTION COUNT: #{@transaction_count}"
    @time_interval = params[:data] ? params[:data][:time_interval].to_i : 500
    puts "TIME INTERVAL: #{@time_interval}"
    @time_intervals = [*1..160].map { |x| x * 500 }
    @transaction_counts = [*1..199].map { |x| x * 50 }
    transactions = Transaction.last(@transaction_count)
    @recent_transactions = Transaction.candlestick_google(transactions, @time_interval)
    @first_transaction = Transaction.first
    @last_transaction = transactions.last
    @transaction_count = Transaction.count
  end
end
