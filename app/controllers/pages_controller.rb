class PagesController < ApplicationController
  def home
    @recent_transactions = Transaction.last(50).reverse
    @first_transaction = Transaction.first
    @last_transaction = @recent_transactions.first
    @transaction_count = Transaction.count
  end
end
