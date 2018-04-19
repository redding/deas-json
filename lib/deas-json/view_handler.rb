require 'deas/view_handler'
require 'much-plugin'

module Deas::Json

  module ViewHandler
    include MuchPlugin

    plugin_included do
      include Deas::ViewHandler

      default_status 200
      default_body   ['{}']

      before_init{ content_type('.json', 'charset' => 'utf-8') }
    end

  end

end
