require 'deas/view_handler'
require 'much-plugin'

module Deas::Json

  module ViewHandler
    include MuchPlugin

    DEF_STATUS  = 200.freeze
    DEF_HEADERS = {}.freeze
    DEF_BODY    = '{}'.freeze

    plugin_included do
      include Deas::ViewHandler
      include InstanceMethods

      before_init{ content_type('.json', 'charset' => 'utf-8') }
    end

    module InstanceMethods

      private

      # Some http clients will error when trying to parse an empty body when the
      # content type is 'json'.  This will default the body to a string that
      # can be parsed to an empty json object.
      # We call the `body` helper method to make sure it adhere's to the Rack spec
      def halt(*args)
        super(
          args.first.instance_of?(::Fixnum) ? args.shift : DEF_STATUS,
          args.first.kind_of?(::Hash) ? args.shift : DEF_HEADERS,
          body(!args.first.to_s.empty? ? args.shift : DEF_BODY)
        )
      end

    end

  end

end
