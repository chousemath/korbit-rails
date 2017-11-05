class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home
    @transaction_count = params[:data] ? params[:data][:transaction_count].to_i : 50
    @time_interval = params[:data] ? params[:data][:time_interval].to_i : 500
    @time_intervals = [*1..160].map { |x| x * 500 }
    @transaction_counts = [*1..199].map { |x| x * 50 }
    transactions = Transaction.last(@transaction_count)
    @recent_transactions = Transaction.candlestick_google(transactions, @time_interval)
    puts @recent_transactions.inspect
    @first_transaction = Transaction.first
    @last_transaction = transactions.last
    @total_transactions = Transaction.count
    flash[:success] = "Current plot represents #{@transaction_count} data points, #{@recent_transactions.count} intervals (#{@time_interval}s each)"
  end
end
