class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
end
