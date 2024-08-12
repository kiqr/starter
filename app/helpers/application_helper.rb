module ApplicationHelper
  def time_ago_in_words(time)
    t("misc.time_ago", time_ago_in_words: super(time))
  end
end
