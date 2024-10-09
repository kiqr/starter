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
    self.account_name = name if account_name.blank?

    ActiveRecord::Base.transaction do
      user.save!
      Member.create!(user: user, account: account, owner: true)
    end
  end
end
