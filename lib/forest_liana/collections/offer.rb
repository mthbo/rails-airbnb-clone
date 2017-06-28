class Forest::Customer
  include ForestLiana::Collection

  collection :offers

  field :pins, type: 'Number' do
    object.pin_count
  end
  field :sessions_closed, type: 'Number' do
    object.deals_closed_count
  end
  field :sessions_ongoing, type: 'Number' do
    object.deals_ongoing_count
  end
  field :satisfaction, type: 'String' do
    "#{(object.satisfaction.fdiv(5) * 100).to_i} %" unless object.satisfaction.nil?
  end
  field :min_amount, type: 'String' do
    "#{object.min_amount.to_f} #{Money.default_currency.symbol}" unless object.min_amount.nil?
  end
  field :median_amount, type: 'String' do
    "#{object.median_amount.to_f} #{Money.default_currency.symbol}" unless object.median_amount.nil?
  end
  field :max_amount, type: 'String' do
    "#{object.max_amount.to_f} #{Money.default_currency.symbol}" unless object.max_amount.nil?
  end
end
