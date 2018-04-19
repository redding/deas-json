require 'assert'
require 'deas-json'

require 'assert-rack-test'
require 'deas'

module Deas::Json

  class RackTestsContext < Assert::Context
    include Assert::Rack::Test

    def app; @app; end
  end

  class RackTests < RackTestsContext
    desc "a Deas server rack app"
    setup do
      @status_val = Factory.integer
      @body_val   = Factory.text

      @app = DeasTestServer.new
    end

    should "use given status/body values" do
      get '/test.json', {
        'status_val' => @status_val,
        'body_val'   => @body_val
      }

      assert_equal @status_val, last_response.status
      assert_equal @body_val,   last_response.body
    end

    should "default its status and body if not provided" do
      get '/test.json'

      assert_equal TestJsonHandler.default_status,     last_response.status
      assert_equal TestJsonHandler.default_body.first, last_response.body
    end

    should "default its body if not provided" do
      get '/test.json', {
        'status_val' => @status_val
      }

      assert_equal @status_val,                        last_response.status
      assert_equal TestJsonHandler.default_body.first, last_response.body
    end

    should "default its status if not provided" do
      get '/test.json', {
        'body_val' => @body_val
      }

      assert_equal TestJsonHandler.default_status, last_response.status
      assert_equal @body_val,                      last_response.body
    end

  end

end

class DeasTestServer
  include Deas::Server

  router do
    get '/test.json', 'TestJsonHandler'
  end

end

class TestJsonHandler
  include Deas::Json::ViewHandler

  attr_accessor :halt_args

  def run!
    halt *([
      (params['status_val'].to_i if params['status_val']),
      params['body_val']
    ].compact)
  end

end

