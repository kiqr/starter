# frozen_string_literal: true

class PageHeader::Component < ApplicationViewComponent
  option :title
  option :description, optional: true
end
