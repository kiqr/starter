class OnboardingForm < FormWizard::Form
  step :terms_and_conditions do
    attribute :toc_accepted
    validates :toc_accepted, acceptance: true, presence: true
  end

  step :profile do
    attribute :full_name
    validates :full_name, presence: true, length: { minimum: 2 }
  end

  step :subscription
end
