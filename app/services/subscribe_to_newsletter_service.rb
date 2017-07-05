class SubscribeToNewsletterService
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @list_id = ENV['MAILCHIMP_LIST_ID']
    @user_mailchimp_id = Digest::MD5.hexdigest(user.email.downcase)
  end

  def call
    begin
      @gibbon.lists(@list_id).members(@user_mailchimp_id).upsert(
        body: {
          email_address: @user.email,
          status: "subscribed",
          merge_fields: {
            FNAME: @user.first_name,
            LNAME: @user.last_name
          },
          language: @user.locale
        }
      )
    rescue Gibbon::MailChimpError => e
      puts "MailChimpError: #{e.message} - #{e.raw_body}"
      return
    end
  end
end
