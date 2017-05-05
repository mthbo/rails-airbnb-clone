class Deal < ApplicationRecord
  include Notifications

  belongs_to :client, class_name: 'User'
  belongs_to :offer
  has_many :objectives, dependent: :destroy
  has_many :deal_means, dependent: :destroy
  has_many :means, through: :deal_means
  has_many :deal_languages, dependent: :destroy
  has_many :languages, through: :deal_languages
  has_many :messages, dependent: :destroy

  monetize :amount_cents, allow_nil: true, numericality: true, with_model_currency: :currency_code
  monetize :fees_cents, allow_nil: true, with_model_currency: :currency_code
  monetize :advisor_amount_cents, allow_nil: true, with_model_currency: :currency_code

  enum status: [ :request, :proposition, :proposition_declined, :opened, :open_expired, :closed, :cancelled ]
  enum payment_state: [ :no_payment, :payment_pending, :paid ]
  enum who_reviews: [ :no_review, :client_is_reviewing, :advisor_is_reviewing]

  validates :request, :languages, :means, :deadline, presence: true

  validate :deadline_must_be_future, if: :pending_or_open?
  validate :deadline_must_be_before_a_year, if: :pending_or_open?

  validates :proposition, presence: true, length: { minimum: 30 }, if: :not_new_nor_cancelled?
  validates :objectives, presence: true, length: { maximum: 10 }, if: :not_new_nor_cancelled?

  validate :amount_must_be_greater_than_min_amount, if: :pending_not_new?
  validate :amount_must_be_less_than_or_equal_to_max_amount, if: :pending_not_new?

  validates :proposition_deadline, presence: true, if: :pending_not_new?
  validate :proposition_deadline_must_be_future, if: :pending_not_new?
  validate :proposition_deadline_must_be_before_deadline, if: :pending_not_new?

  validates :client_review, presence: true, length: { maximum: 500 }, if: :client_is_reviewing?
  validates :client_rating, presence: true, if: :client_is_reviewing?
  validates :client_rating, numericality: { only_integer: true }, inclusion: { in: [1,2,3,4,5] }, if: :client_is_reviewing?
  validate :objectives_must_be_rated, if: :client_is_reviewing?

  validates :advisor_review, presence: true, length: { maximum: 500 }, if: :advisor_is_reviewing?
  validates :advisor_rating, presence: true, if: :advisor_is_reviewing?
  validates :advisor_rating, numericality: { only_integer: true }, inclusion: { in: [1,2,3,4,5] }, if: :advisor_is_reviewing?

  after_create_commit :create_first_message

  def advisor
    offer.advisor unless offer.nil?
  end


  # Money

  def currency
    Money::Currency.find(self.currency_code) ? Money::Currency.find(self.currency_code) : Money.default_currency
  end

  def flat_fee
    Money.new(50, "EUR").exchange_to(self.currency_code)
  end

  def first_cutoff_amount
    Money.new(5000, "EUR").exchange_to(self.currency_code)
  end

  def set_fees
    if self.amount_cents
      if self.amount_cents > first_cutoff_amount.cents
        self.fees_cents = flat_fee.cents + first_cutoff_amount.cents * 0.15 + (self.amount_cents - first_cutoff_amount.cents) * 0.1
      else
        self.fees_cents = flat_fee.cents + self.amount_cents * 0.15
      end
    end
  end

  def advisor_amount_cents
    if amount_cents && fees_cents
      amount_cents - fees_cents
    end
  end

  def min_amount
    Money.new(1000, "EUR").exchange_to(self.advisor.currency_code)
  end

  def max_amount
    Money.new(200000, "EUR").exchange_to(self.advisor.currency_code)
  end

  def amount_converted(currency_code=Money.default_currency.to_s)
    amount.exchange_to(currency_code) if amount
  end

  def fees_converted(currency_code=Money.default_currency.to_s)
    fees.exchange_to(currency_code) if fees
  end

  def advisor_amount_converted(currency_code=Money.default_currency.to_s)
    advisor_amount.exchange_to(currency_code) if advisor_amount
  end


  # Status

  def proposition_any?
    proposition? || proposition_declined?
  end

  def pending?
    request? || proposition_any?
  end

  def pending_or_open?
    pending? || opened?
  end

  def open_or_expired?
    opened? || open_expired?
  end

  def pending_not_new?
    (request? && id.present?) || proposition_any?
  end

  def not_new_nor_cancelled?
    pending_not_new? || open_or_expired? || closed?
  end

  def reviewed_by_advisor?
    advisor_review_at.present?
  end

  def reviewed_by_client?
    client_review_at.present?
  end

  def general_status
    if request?
      "request"
    elsif proposition_any?
      "proposition"
    elsif open_or_expired?
      "open"
    elsif closed? && closed_at > 1.month.ago
      "closed_recent"
    elsif closed? && closed_at <= 1.month.ago
      "closed_old"
    elsif cancelled?
      "cancelled"
    end
  end

  def card_status
    if proposition?
      'proposition_pending'
    elsif proposition_declined?
      'proposition_declined'
    elsif open_expired?
      'deadline_expired'
    elsif messages_disabled?
      'messages_disabled'
    elsif closed? && (!reviewed_by_client? || !reviewed_by_advisor?)
      'review_expected'
    end
  end

  def free?
    (offer.free? if offer) || (!request? && (amount_cents.blank? || amount_cents.zero?))
  end

  def video_call?
    means.include?(Mean.find_by_name("Video call"))
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

  # Evaluations

  EVALUATIONS = {
    1 => 'disapointing',
    2 => 'ordinary',
    3 => 'all_right',
    4 => 'great',
    5 => 'amazing'
  }

  def self.evaluations
    (1..5).to_a.map { |rating| [rating, {'data-html' => I18n.t("deal.#{EVALUATIONS[rating]}") }] }
  end

  def client_evaluation
    I18n.t("deal.#{EVALUATIONS[client_rating]}")
  end

  def advisor_evaluation
    I18n.t("deal.#{EVALUATIONS[advisor_rating]}")
  end

  private

  def create_first_message
    message = Message.new(deal: self, user: self.client, content: self.request)
    message.save
  end

  # Validations

  def amount_must_be_greater_than_min_amount
    errors.add(:amount, :greater_than_or_equal_to, amount: min_amount.to_i, currency: advisor.currency.symbol ) if
      amount.present? && amount.to_i < min_amount.to_i
  end

  def amount_must_be_less_than_or_equal_to_max_amount
    errors.add(:amount, :less_than_or_equal_to, amount: max_amount.to_i, currency: advisor.currency.symbol ) if
      amount.present? && amount.to_i > max_amount.to_i
  end

  def deadline_must_be_future
    errors.add(:deadline, :past) if
      deadline.present? && deadline <= 1.day.ago
  end

  def deadline_must_be_before_a_year
    errors.add(:deadline, :more_than_a_year_from_now) if
      deadline.present? && deadline > 1.year.from_now
  end

  def proposition_deadline_must_be_future
    errors.add(:proposition_deadline, :past) if
      proposition_deadline.present? && proposition_deadline <= 1.day.ago
  end

  def proposition_deadline_must_be_before_deadline
    errors.add(:proposition_deadline, :after_deadline) if
      proposition_deadline.present? && proposition_deadline > deadline
  end

  def objectives_must_be_rated
    errors.add(:objectives) if
      !(objectives.all? { |objective| objective.rating.present? })
  end

end
