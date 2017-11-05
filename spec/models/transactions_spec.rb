require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it "is valid with valid attributes" do
    transaction = Transaction.new(unix_time: 1378189897, value_krw: 160000, value_btc: 0.100000000000)
    expect(transaction).to be_valid
    transaction.save!
    last_transaction = Transaction.last
    expect(last_transaction['unix_time']).to eq(1378189897)
    expect(last_transaction['value_krw']).to eq(160000)
    expect(last_transaction['value_btc']).to eq(0.1)
  end
end
