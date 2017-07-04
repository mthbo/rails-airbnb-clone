class ContactMessage
  include ActiveModel::Model
  attr_accessor :subject, :email, :body, :user_id
  validates :subject, :email, :body, presence: true
  validates_email_format_of :email

  def self.i18n_scope
    :activerecord
  end
end
