class Forest::Customer
  include ForestLiana::Collection

  collection :deals

  field :total_amount, type: 'String' do
    "#{object.amount.to_f} #{object.currency.symbol}" unless object.amount.nil?
  end
  field :fees, type: 'String' do
    "#{object.fees.to_f} #{object.currency.symbol}" unless object.fees.nil?
  end
  field :objectives_count, type: 'Number' do
    object.objectives_count
  end
  field :client_satisfaction, type: 'String' do
    "#{(object.client_global_rating.fdiv(5) * 100).to_i} %" unless object.client_global_rating.nil?
  end
  field :advisor_satisfaction, type: 'String' do
    "#{(object.advisor_global_rating.fdiv(5) * 100).to_i} %" unless object.advisor_global_rating.nil?
  end

end
