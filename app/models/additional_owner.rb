class AdditionalOwner < ApplicationRecord
  belongs_to :user

  default_scope -> { order(created_at: :ASC) }

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :birth_date, presence: true
  validates :address, presence: true
  validate :birth_date_must_be_valid
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :country_code, presence: true, allow_blank: false

  private

  # Validations

  def birth_date_must_be_valid
    errors.add(:birth_date) if
      birth_date.present? && (birth_date > DateTime.current.in_time_zone || birth_date < 130.years.ago)
  end
end
