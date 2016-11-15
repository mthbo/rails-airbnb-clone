class Deal < ApplicationRecord
  belongs_to :client_id, class_name: 'User'
  belongs_to :offer
end
