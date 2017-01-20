class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  has_many :objectives, dependent: :destroy
  has_many :deal_means, dependent: :destroy
  has_many :means, through: :deal_means
  has_many :deal_languages, dependent: :destroy
  has_many :languages, through: :deal_languages
  has_many :messages, dependent: :destroy

  monetize :amount_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

  enum status: [ :request, :proposition, :proposition_declined, :open, :open_expired, :closed, :cancelled ]
  enum who_reviews: [ :no_review, :client_is_reviewing, :advisor_is_reviewing]

  validates :request, presence: { message: "Detail your request" }
  validates :languages, presence: { message: "Select one language at least" }
  validates :means, presence: { message: "Select one mean of communication at least" }

  validates :deadline, presence: { message: "Specify a deadline for your request" }
  validate :deadline_must_be_future, if: :pending_or_open?
  validate :deadline_must_be_before_a_year, if: :pending_or_open?

  validates :proposition, presence: { message: "The proposition must be described" }, length: { minimum: 50, message: "The description is too short, please tell a little more!" }, if: :not_new_nor_cancelled?
  validates :objectives, presence: true, length: { in: 1..10 }, if: :not_new_nor_cancelled?

  validates :proposition_deadline, presence: { message: "Specify an expiry date for your proposition" }, if: :pending_not_new?
  validate :proposition_deadline_must_be_future, if: :pending_not_new?
  validate :proposition_deadline_must_be_before_deadline, if: :pending_not_new?

  validates :client_review, presence: { message: "Please write a short review" }, if: :client_is_reviewing?
  validates :client_rating, presence: { message: "Please rate the session" }, if: :client_is_reviewing?
  validates :client_rating, numericality: { only_integer: true }, inclusion: { in: [0,1,2,3,3,4,5], message: "Rate from 0 to 5 stars"}, if: :client_is_reviewing?
  validate :objectives_must_be_rated, if: :client_is_reviewing?

  validates :advisor_review, presence: { message: "Please write a short review" }, if: :advisor_is_reviewing?
  validates :advisor_rating, presence: { message: "Please rate the session" }, if: :advisor_is_reviewing?
  validates :advisor_rating, numericality: { only_integer: true }, inclusion: { in: [0,1,2,3,3,4,5], message: "Rate from 0 to 5 stars"}, if: :advisor_is_reviewing?

  def advisor
    offer.advisor unless offer.nil?
  end


  # Status

  def proposition_any?
    proposition? || proposition_declined?
  end

  def pending?
    request? || proposition_any?
  end

  def pending_or_open?
    pending? || open?
  end

  def open_or_expired?
    open? || open_expired?
  end

  def pending_not_new?
    (request? && id.present?) || proposition_any?
  end

  def not_new_nor_cancelled?
    pending_not_new? || open_or_expired? || closed?
  end


  # Stats

  def objectives_count
    objectives.count
  end

  def client_global_rating
    if rated_objectives.present? && client_rating.present?
      sum = 0
      rated_objectives.each { |objective| sum += objective.rating }
      objectives_rating = sum.fdiv(rated_objectives.count)
      0.75 * objectives_rating + 0.25 * client_rating
    end
  end

  def rated_objectives
    objectives.where.not(rating: nil)
  end

  def advisor_global_rating
    if advisor_rating.present?
      advisor_rating
    end
  end


  private

  # Validations

  def deadline_must_be_future
    errors.add(:deadline, "The deadline can't be in the past ") if
      deadline.present? && deadline <= 1.day.ago
  end

  def deadline_must_be_before_a_year
    errors.add(:deadline, "The deadline can't be later than a year from now") if
      deadline.present? && deadline > 1.year.from_now
  end

  def proposition_deadline_must_be_future
    errors.add(:proposition_deadline, "The expiry date can't be in the past") if
      proposition_deadline.present? && proposition_deadline <= 1.day.ago
  end

  def proposition_deadline_must_be_before_deadline
    errors.add(:proposition_deadline, "The expiry date can't be later than the proposition deadline") if
      proposition_deadline.present? && proposition_deadline > deadline
  end

  def objectives_must_be_rated
    errors.add(:objectives, "All objectives must be rated") if
      !(objectives.all? { |objective| objective.rating.present? })
  end

end
