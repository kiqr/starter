module ApplicationHelper
  def time_ago_in_words(time)
    t("misc.time_ago", time_ago_in_words: super(time))
  end

  def invitation_token_to_url(token)
      user_invitation_url(token: token, account_id: nil)
  end
end
