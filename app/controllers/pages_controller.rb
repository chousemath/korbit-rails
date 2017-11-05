class PagesController < ApplicationController
  def home
    transaction_count = params[:transaction_count] || 50
    time_interval = params[:time_interval] || 500
    transactions = Transaction.last(transaction_count)
    @recent_transactions = Transaction.candlestick_google(transactions, time_interval)
    @first_transaction = Transaction.first
    @last_transaction = transactions.last
    @transaction_count = Transaction.count
  end
end
