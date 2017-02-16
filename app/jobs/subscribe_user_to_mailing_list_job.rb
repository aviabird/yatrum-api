class SubscribeUserToMailingListJob < ApplicationJob
  queue_as :default

  def perform(user)
    gb = Gibbon::Request.new

    list_id = ENV["MAILCHIMP_LIST_ID"]

    gb.lists(list_id)
      .members
      .create(body: { email_address: user.email,
                      status: "subscribed",
                      merge_fields: { FNAME: user.name || "Random User", MMERGE3: "http://developer.mailchimp.com", MMERGE5: "http://twitter.com/_voidzero"}})
    end
end
