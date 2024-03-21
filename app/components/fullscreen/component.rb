# frozen_string_literal: true

class Fullscreen::Component < ApplicationViewComponent
  renders_one :announcement, "Fullscreen::Announcement::Component"
  renders_one :form, "Fullscreen::Form::Component"
end
