class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :unix_time
      t.float :value_krw
      t.float :value_btc

      t.timestamps
    end
  end
end
