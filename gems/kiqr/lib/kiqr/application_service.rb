module Kiqr
  # ApplicationService is a base class for all services in the application.
  # It provides a common interface for all services and a way to handle errors.
  # It also provides a way to propagate errors to the caller or to handle them
  # internally.
  class ApplicationService
    Response = Struct.new(:success?, :payload, :error) do
      def failure?
        !success?
      end
    end

    def initialize(propagate = true)
      @propagate = propagate
    end

    def self.call(...)
      service = new(false)
      service.call(...)
    rescue => e
      service.failure(e)
    end

    def self.call!(...)
      new(true).call(...)
    end

    def success(payload = nil)
      Response.new(true, payload)
    end

    def failure(exception, options = {})
      raise exception if @propagate

      # ErrorService.error(exception, options)
      Response.new(false, nil, exception)
    end
  end
end
