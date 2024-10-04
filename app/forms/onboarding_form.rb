class OnboardingForm < FormWizard::Form
  step :terms_and_conditions do
    attribute :toc_accepted
    validates :toc_accepted, acceptance: true, presence: true
  end

  step :profile do
    attribute :name
    validates :name, presence: true, length: { minimum: 2 }

    attribute :account_name
    validates :account_name, presence: true, length: { minimum: 5 }, allow_blank: true

    attribute :locale
    attribute :time_zone
  end

  def persist
    "it works"
  end
end
