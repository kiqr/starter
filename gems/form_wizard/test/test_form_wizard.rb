# frozen_string_literal: true

require "test_helper"

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

class TestFormWizard < Minitest::Test
  def setup
    @session = {}
    @form = OnboardingForm.new(session: @session)
  end

  def test_steps_are_configured
    assert_equal %i[terms_and_conditions profile subscription], @form.steps
  end

  def test_current_step_is_first_step
    assert_equal :terms_and_conditions, @form.current_step
  end

  def test_next_step_is_correct
    @form.current_step = :profile
    assert_equal :subscription, @form.next_step
  end

  def test_final_step_returns_false
    assert_equal false, @form.final_step?
  end

  def test_final_step_returns_true
    @form.current_step = :subscription
    assert @form.final_step?
  end

  def test_attributes_are_configured
    assert_equal %w[toc_accepted full_name], @form.class.attribute_names
  end

  def test_attribute_assignment
    @form.assign_attributes(toc_accepted: "1", full_name: "Bob")
    assert_equal "1", @form.toc_accepted
    assert_equal "Bob", @form.full_name
  end

  def test_attributes_returns_correct_values
    @form.assign_attributes(toc_accepted: "1", full_name: "Alice")
    assert_equal({ "toc_accepted" => "1", "full_name" => "Alice" }, @form.attributes)
  end

  def test_navigation_through_steps
    assert_equal :terms_and_conditions, @form.current_step
    assert_equal :profile, @form.next_step

    @form.current_step = @form.next_step
    assert_equal :profile, @form.current_step
    assert_equal :subscription, @form.next_step

    @form.current_step = @form.next_step
    assert_equal :subscription, @form.current_step
    assert_nil @form.next_step
    assert_equal true, @form.final_step?
  end

  def test_validations_on_current_step
    # Test without accepting T&C
    @form.assign_attributes(toc_accepted: "0")
    assert_equal false, @form.valid?
    assert_includes @form.errors[:toc_accepted], "must be accepted"

    # Test with accepting T&C
    @form.assign_attributes(toc_accepted: "1")
    assert_equal true, @form.valid?
  end

  def test_validations_not_run_on_other_steps
    @form.current_step = :profile
    @form.assign_attributes(full_name: "A")
    assert_equal false, @form.valid?
    assert_includes @form.errors[:full_name], "is too short (minimum is 2 characters)"

    # toc_accepted should not be validated in this step
    assert_empty @form.errors[:toc_accepted]
  end

  def test_store_and_load_from_session
    # Simulate filling out the first step
    @form.update(toc_accepted: "1")
    assert_equal "1", @form.toc_accepted
    assert_equal({ "toc_accepted" => "1", "full_name" => nil }, @session["form_wizard_data"])

    # Simulate moving to the next step and reloading form
    new_form = OnboardingForm.new(session: @session, step: "profile")
    assert_equal "1", new_form.toc_accepted
    assert_equal :profile, new_form.current_step
  end

  def test_persist_method_not_implemented
    assert_raises(NotImplementedError) { @form.persist }
  end

  def test_complete_flow
    # Step 1: Terms and Conditions
    @form.current_step = :terms_and_conditions
    assert_equal false, @form.update(toc_accepted: "0")
    assert_includes @form.errors[:toc_accepted], "must be accepted"

    assert_equal true, @form.update(toc_accepted: "1")
    @form.current_step = @form.next_step

    # Step 2: Profile
    assert_equal :profile, @form.current_step
    assert_equal false, @form.update(full_name: "A")
    assert_includes @form.errors[:full_name], "is too short (minimum is 2 characters)"

    assert_equal true, @form.update(full_name: "Alice")
    @form.current_step = @form.next_step

    # Step 3: Subscription
    assert_equal :subscription, @form.current_step

    # Assuming no validations here
    assert_equal true, @form.update({})
    assert_equal true, @form.final_step?
  end
end