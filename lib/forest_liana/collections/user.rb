class Forest::Customer
  include ForestLiana::Collection

  collection :users

  field :avatar, type: 'String' do
    object.avatar_link
  end
  field :age, type: 'Number' do
    object.age
  end
  field :grade, type: 'String' do
    object.grade
  end
  field :active_offers, type: 'Number' do
    object.offers_active_count
  end
  field :priced_offers, type: 'Number' do
    object.offers_priced_count
  end
  field :client_sessions_closed, type: 'Number' do
    object.client_deals_closed_count
  end
  field :client_sessions_ongoing, type: 'Number' do
    object.client_deals_ongoing_count
  end
  field :advisor_sessions_closed, type: 'Number' do
    object.advisor_deals_closed_count
  end
  field :advisor_sessions_ongoing, type: 'Number' do
    object.advisor_deals_ongoing_count
  end
end
