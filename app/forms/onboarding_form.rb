class OnboardingForm < FormWizard::Form
  step :terms_and_conditions do
    attribute :toc_accepted
    validates :toc_accepted, acceptance: true, presence: true
  end

  step :profile do
    attribute :name, on: :profile
    validates :name, presence: true, length: { minimum: 2 }

    attribute :account_name, on: :account, column: :name
    validates :account_name, presence: true, length: { minimum: 5 }, allow_blank: true

    attribute :locale, on: :user
    attribute :time_zone, on: :user
  end

  def persist
  end

  private

  def user
    @models[:user]
  end

  def account
    @models[:account]
  end
end
