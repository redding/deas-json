require 'deas/view_handler'

module Deas::Json

  module ViewHandler

    DEF_STATUS  = nil
    DEF_HEADERS = {}.freeze
    DEF_BODY    = '{}'.freeze

    def self.included(klass)
      klass.class_eval do
        include Deas::ViewHandler
        include InstanceMethods
      end
    end

    module InstanceMethods

      def initialize(*args)
        super(*args)
        content_type :json
      end

      private

      # Some http clients will error when trying to parse an empty body when the
      # content type is 'json'.  This will default the body to a string that
      # can be parsed to an empty json object
      def halt(*args)
        super(DEF_STATUS, DEF_HEADERS, DEF_BODY) if args.empty?
        body, headers, status = [
          !args.last.kind_of?(::Hash) && !args.last.kind_of?(::Integer) ? args.pop : DEF_BODY,
          args.last.kind_of?(::Hash) ? args.pop : DEF_HEADERS,
          args.first.kind_of?(::Integer) ? args.first : DEF_STATUS
        ]
        super(status, headers, body)
      end

    end

  end

end
