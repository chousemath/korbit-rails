require 'csv'
require 'json'

def retrieve_data_window(data_path)
  CSV.foreach(data_path) do |row|
    Transaction.create!(unix_time: row[0].to_i, value_krw: row[1].to_f, value_btc: row[2].to_f)
  end
end

data_path = "#{Rails.root}/app/assets/files/small.csv"
retrieve_data_window(data_path)
