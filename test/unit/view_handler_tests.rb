require 'assert'
require 'deas-json/view_handler'

require 'deas/test_helpers'
require 'deas/view_handler'

module Deas::Json::ViewHandler

  class UnitTests < Assert::Context
    desc "Deas::Json::ViewHandler"
    setup do
      @handler_class = TestJsonHandler
    end
    subject{ @handler_class }

    should "be a deas view handler" do
      assert_includes Deas::ViewHandler, subject
    end

    should "know its default status, headers and body values" do
      assert_equal nil,      subject::DEF_STATUS
      assert_equal Hash.new, subject::DEF_HEADERS
      assert_equal '{}',     subject::DEF_BODY
    end

  end

  class InitTests < UnitTests
    include Deas::TestHelpers

    desc "when init"
    setup do
      @runner  = test_runner(@handler_class)
      @handler = @runner.handler
    end
    subject{ @runner }

    should "force its content type to :json" do
      assert_equal :json, subject.content_type.value
    end

    should "use all given args" do
      @handler.status  = Factory.integer
      @handler.headers = { Factory.string => Factory.string }
      @handler.body    = Factory.text
      response = @runner.run

      assert_equal @handler.status,  response.status
      assert_equal @handler.headers, response.headers
      assert_equal @handler.body,    response.body
    end

    should "default its status, headers and body if not provided" do
      response = @runner.run

      assert_equal DEF_STATUS,  response.status
      assert_equal DEF_HEADERS, response.headers
      assert_equal DEF_BODY,    response.body
    end

    should "default its headers and body if not provided" do
      @handler.status = Factory.integer
      response = @runner.run

      assert_equal @handler.status, response.status
      assert_equal DEF_HEADERS,     response.headers
      assert_equal DEF_BODY,        response.body
    end

    should "default its status and body if not provided" do
      @handler.headers = { Factory.string => Factory.string }
      response = @runner.run

      assert_equal DEF_STATUS,       response.status
      assert_equal @handler.headers, response.headers
      assert_equal DEF_BODY,         response.body
    end

    should "default its status and headers if not provided" do
      @handler.body = Factory.text
      response = @runner.run

      assert_equal DEF_STATUS,    response.status
      assert_equal DEF_HEADERS,   response.headers
      assert_equal @handler.body, response.body
    end

    should "default its status if not provided" do
      @handler.headers = { Factory.string => Factory.string }
      @handler.body = Factory.text
      response = @runner.run

      assert_equal DEF_STATUS,       response.status
      assert_equal @handler.headers, response.headers
      assert_equal @handler.body,    response.body
    end

    should "default its headers if not provided" do
      @handler.status = Factory.integer
      @handler.body = Factory.text
      response = @runner.run

      assert_equal @handler.status, response.status
      assert_equal DEF_HEADERS,     response.headers
      assert_equal @handler.body,   response.body
    end

    should "default its body if not provided" do
      @handler.status  = Factory.integer
      @handler.headers = { Factory.string => Factory.string }
      response = @runner.run

      assert_equal @handler.status,  response.status
      assert_equal @handler.headers, response.headers
      assert_equal DEF_BODY,         response.body
    end

  end

  class TestJsonHandler
    include Deas::Json::ViewHandler

    attr_accessor :status, :headers, :body

    def run!
      args = [status, headers, body].compact
      halt *args
    end

  end

end
