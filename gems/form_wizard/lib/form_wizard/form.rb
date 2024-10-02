# # frozen_string_literal: true

require "active_model"

module FormWizard
  class Form
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :current_step

    def initialize(session: {}, step: nil)
      @session = session
      @current_step = step&.to_sym || first_step
      load_from_session
    end

    def to_partial_path
      @current_step.to_s
    end

    def update(params)
      assign_attributes(params)
      store_in_session
      valid?
    end

    def persist
      raise NotImplementedError, "You must implement the persist method"
    end

    def steps
      self.class.steps
    end

    def previous_step
      steps[idx - 1]
    end

    def next_step
      steps[idx + 1]
    end

    def final_step?
      @current_step.to_sym == steps.last
    end

    def attributes
      attrs = {}
      self.class.attribute_names.each do |attr_name|
        attrs[attr_name] = send(attr_name)
      end
      attrs
    end

    class << self
      def attribute_names
        @attribute_names ||= []
      end

      # Stores the steps defined in the wizard
      def steps
        @steps ||= []
      end

      # Defines a step with a given name and block
      def step(name, &block)
        steps << name.to_sym
        builder = StepBuilder.new(self, name)
        builder.instance_eval(&block) if block_given?
      end
    end

    private

    def idx
      steps.index(@current_step.to_sym)
    end

    # Session Management
    def session_key
      # self.class.name.underscore
      "form_wizard_data"
    end

    def load_from_session
      data = @session[session_key] || {}
      assign_attributes(data)
    end

    def store_in_session
      @session[session_key] = attributes
    end

    def clear_session
      @session.delete(session_key)
    end

    def first_step
      self.class.steps.first.to_sym
    end

    class StepBuilder
      attr_reader :attributes, :validations

      def initialize(wizard_class, name)
        @wizard_class = wizard_class
        @name = name
        @attributes = []
        @validations = []
      end

      def attribute(attr_name)
        attr_name = attr_name.to_s
        @attributes << attr_name

        unless @wizard_class.attribute_names.include?(attr_name)
          @wizard_class.attribute_names << attr_name
          @wizard_class.attr_accessor attr_name
        end
      end

      def validates(*args)
        options = args.extract_options!.dup
        step_name = @name.to_s  # Capture the step name
        step_condition = -> { current_step.to_s == step_name }

        if options[:if]
          original_condition = options[:if]
          options[:if] = -> { step_condition.call && instance_exec(&original_condition) }
        else
          options[:if] = step_condition
        end

        @wizard_class.validates(*args, **options)
      end
    end
  end
end
