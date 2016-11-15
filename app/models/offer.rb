class Offer < ApplicationRecord
  belongs_to :advisor_id, class_name: 'User'
end
