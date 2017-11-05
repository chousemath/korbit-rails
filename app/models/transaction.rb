class Transaction < ApplicationRecord
  validates :unix_time,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :value_krw, presence: true, numericality: true
  validates :value_btc, presence: true, numericality: true

  def self.candlestick(data, period)
    start_time = nil # will be initialized at the start of the loop
    end_time = 0
    prices = [] # contains all the prices over a period
    coins = [] # contains all btc trade volumes over a period
    formatted_data = []
    data.each do |row|
      # initialize a start_time
      start_time = row.unix_time unless start_time
      if row.unix_time - start_time > period
        # this accounts for the case where you overshoot the period
        # as a result, use up to the previous data row for calculations
        formatted_data << format_json(prices, start_time, end_time, coins)
        # need to reset values
        start_time = start_time + period
        prices = []
        coins = []
      elsif row.unix_time - start_time == period
        # case where the end_time falls exactly on a open_time + period
        end_time = row.unix_time
        prices << row.value_krw.to_i
        coins << row.value_btc
        formatted_data << format_json(prices, start_time, end_time, coins)
        # need to reset values
        start_time = start_time + period
        prices = []
        coins = []
      end

      # accumulate CSV data
      # I do this at the end of the loop to account for overshooting the period
      end_time = row.unix_time
      prices << row.value_krw.to_i
      coins << row.value_btc
    end
    formatted_data
  end

  def self.candlestick_google(data, period)
    candlestick(data, period).map do |t|
      start_time = DateTime.strptime(t[:start].to_s, '%s').strftime('%Y%m%dT%H%M')
      end_time = DateTime.strptime(t[:end].to_s, '%s').strftime('%Y%m%dT%H%M')
      # [start_time + ' - ' + end_time, t[:low], t[:open], t[:close], t[:high]]
      ["#{start_time} - #{end_time}", t[:low], t[:open], t[:close], t[:high], t[:average].to_i, t[:weighted_average].to_i]
    end
  end

  private

  def self.btc_volume(coins)
    # for units of BTC round to the nearest Satoshi
    '%.8f' % (((coins.inject(:+)) * 100_000_000).round / 100_000_000.0).to_s
  end

  def self.calc_avg(prices)
    # For units of KRW round to the nearest ones digit
    (prices.inject(:+).to_f / prices.size).round.to_s
  end

  def self.calc_weighted_avg(prices, coins)
    # I am making the assumption that the weight average is calculated by considering
    # the btc trade volume for any particular day relative to the total btc trade volume
    # over the period of time
    total_btc = coins.inject(:+)
    # multiply each price by its btc weight
    weighted_prices = prices.each_with_index.map { |x, i| x * coins[i]/total_btc }
    weighted_prices.inject(:+).round.to_s
  end

  def self.format_json(prices, start_time, end_time, coins)
    {
      open: prices[0],
      close: prices[-1],
      high: prices.max,
      low: prices.min,
      start: start_time,
      end: end_time.to_i,
      average: calc_avg(prices),
      weighted_average: calc_weighted_avg(prices, coins),
      volume: btc_volume(coins)
    }
  end
end
