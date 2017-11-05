class Transaction < ApplicationRecord
  validates :unix_time,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :value_krw, presence: true, numericality: true
  validates :value_btc, presence: true, numericality: true
end
