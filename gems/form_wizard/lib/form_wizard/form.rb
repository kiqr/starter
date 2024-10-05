# # frozen_string_literal: true

require "active_model"

module FormWizard
  class Form
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :current_step

    def initialize(session: {}, step: nil, models: {})
      @session = session
      @current_step = step&.to_sym || first_step
      @models = models

      # Assign default values first
      assign_default_values

      # Load data from models if any
      load_from_models

      # Load data from session, which overrides defaults and models
      load_from_session
    end

    def update(params)
      assign_attributes(params)
      return false unless valid?

      store_in_session
      true
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

    def to_partial_path
      @current_step.to_s
    end

    class << self
      def attribute_names
        @attribute_names ||= []
      end

      def attribute_mappings
        @attribute_mappings ||= {}
      end

      def default_values
        @default_values ||= {}
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

      def attr_accessor_with_model_sync(attr_name)
        attr_name = attr_name.to_sym

        define_method("#{attr_name}=") do |value|
          # Set the form's instance variable
          instance_variable_set("@#{attr_name}", value)

          # Update the mapped model attribute if mapping exists
          mapping = self.class.attribute_mappings[attr_name]
          if mapping
            model_name = mapping[:model]
            model_attr = mapping[:attribute]

            model = @models[model_name]
            if model
              model.send("#{model_attr}=", value)
            else
              raise "Model #{model_name} not provided"
            end
          end
        end

        define_method(attr_name) do
          instance_variable_get("@#{attr_name}")
        end
      end
    end

    private

    def idx
      steps.index(@current_step.to_sym)
    end

    # Session Management
    def session_key
      # self.class.name.underscore
      "form_wizard_#{self.class.name.underscore}_data"
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

    def assign_default_values
      self.class.default_values.each do |attr_name, value|
        send("#{attr_name}=", value)
      end
    end

    def load_from_models
      self.class.attribute_mappings.each do |form_attr, mapping|
        model_name = mapping[:model]
        model_attr = mapping[:attribute]

        model = @models[model_name] || (raise "Model #{model_name} not provided")

        value = model.send(model_attr) if model.respond_to?(model_attr)
        send("#{form_attr}=", value)
      end
    end

    class StepBuilder
      attr_reader :attributes, :validations

      def initialize(wizard_class, name)
        @wizard_class = wizard_class
        @name = name
        @attributes = []
        @validations = []
      end

      def attribute(attr_name, **options)
        options = options.symbolize_keys

        attr_name = attr_name.to_sym
        default_value = options[:default]
        on_model = options[:on]&.to_sym
        model_attr_name = options.fetch(:column, attr_name)

        @attributes << attr_name
        unless @wizard_class.attribute_names.include?(attr_name)
          @wizard_class.attribute_names << attr_name

          # Use the custom accessor
          @wizard_class.attr_accessor_with_model_sync attr_name

          # Store default value if provided
          @wizard_class.default_values[attr_name] = default_value if default_value

          # Store mapping only if :on is specified
          if on_model
            @wizard_class.attribute_mappings[attr_name] = { model: on_model, attribute: model_attr_name }
          end
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
