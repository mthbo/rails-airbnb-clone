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
  monetize :fees_excluding_vat_cents, allow_nil: true, with_model_currency: :currency_code
  monetize :fees_vat_cents, allow_nil: true, with_model_currency: :currency_code
  monetize :advisor_amount_cents, allow_nil: true, with_model_currency: :currency_code

  enum status: [ :request, :proposition, :proposition_declined, :opened, :open_expired, :closed, :cancelled ]
  enum payment_state: [ :no_payment, :payment_pending, :paid, :payout_pending, :payout_made, :payout_paid, :payout_failed ]
  enum who_reviews: [ :no_review, :client_is_reviewing, :advisor_is_reviewing]

  validates :request, :languages, :means, :deadline, presence: true

  validate :deadline_must_be_future, if: :pending_or_open?
  validate :deadline_must_be_before_limit, if: :pending_or_open?

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
    Money.new(ENV['PRICING_FLAT_FEE'].to_i, "EUR").exchange_to(self.currency_code)
  end

  def first_cutoff_amount
    Money.new(ENV['PRICING_FIRST_CUTOFF'].to_i, "EUR").exchange_to(self.currency_code)
  end

  def set_fees
    if self.amount_cents
      if self.amount_cents > first_cutoff_amount.cents
        self.fees_cents = flat_fee.cents + first_cutoff_amount.cents * ENV['PRICING_FIRST_RATE'].to_f + (self.amount_cents - first_cutoff_amount.cents) * ENV['PRICING_SECOND_RATE'].to_f
      else
        self.fees_cents = flat_fee.cents + self.amount_cents * ENV['PRICING_FIRST_RATE'].to_f
      end
    end
  end

  def fees_excluding_vat_cents
    fees_cents.fdiv(1 + ENV['PRICING_FEES_VAT_RATE'].to_f).round if fees_cents
  end

  def fees_vat_cents
    (fees_cents - fees_excluding_vat_cents) if fees_cents
  end

  def advisor_amount_cents
    (amount_cents - fees_cents) if (amount_cents && fees_cents)
  end

  def min_amount
    Money.new(ENV['PRICING_MIN_AMOUNT'].to_i, "EUR").exchange_to(self.advisor.currency_code)
  end

  def max_amount
    Money.new(ENV['PRICING_MAX_AMOUNT'].to_i, "EUR").exchange_to(self.advisor.currency_code)
  end

  def amount_converted(currency_code=Money.default_currency.to_s)
    amount.exchange_to(currency_code) if amount
  end

  def fees_converted(currency_code=Money.default_currency.to_s)
    fees.exchange_to(currency_code) if fees
  end

  def fees_excluding_vat_converted(currency_code=Money.default_currency.to_s)
    fees_excluding_vat.exchange_to(currency_code) if fees_excluding_vat
  end

  def fees_vat_converted(currency_code=Money.default_currency.to_s)
    fees_vat.exchange_to(currency_code) if fees_vat
  end

  def advisor_amount_converted(currency_code=Money.default_currency.to_s)
    advisor_amount.exchange_to(currency_code) if advisor_amount
  end

  def payout_triggered_at
    [closed_at + ENV['PAYOUT_DELAY'].to_i.days, opened_at + ENV['PAYOUT_DELAY_MIN'].to_i.days].max if closed_at.present?
  end

  def payout_created_at
    if payout.present?
      timestamp = JSON.parse(self.payout)["created"]
      Time.at(timestamp).to_datetime.in_time_zone
    end
  end

  def payout_arrival_at
    if payout.present?
      timestamp = JSON.parse(self.payout)["arrival_date"]
      Time.at(timestamp).to_datetime.in_time_zone
    end
  end

  def payment_bank_brand
    JSON.parse(self.payment)["source"]["brand"] if payment.present?
  end

  def payment_bank_last4
    JSON.parse(self.payment)["source"]["last4"] if payment.present?
  end

  def payment_receipt_number
    "R#{self.opened_at.strftime('%y%j')}-#{self.id}" if opened_at.present?
  end

  def transaction_receipt_number
    "T#{self.payout_created_at.strftime('%y%j')}-#{self.id}" if payout_created_at.present?
  end

  def automatic_closed_at
    opened_at + ENV['PAYOUT_LIMIT'].to_i.days - 4.days if opened_at.present?
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

  def messages_count
    messages.count
  end

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

  def deadline_must_be_before_limit
    errors.add(:deadline, :after_limit, days: ENV['PAYOUT_LIMIT'].to_i - 5) if
      deadline.present? && deadline > (ENV['PAYOUT_LIMIT'].to_i - 5).days.from_now
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
