require 'assert'
require 'deas-json/view_handler'

require 'deas/view_handler'

module Deas::Json::ViewHandler

  class UnitTests < Assert::Context
    desc "Deas::Json::ViewHandler"
    setup do
      @handler_class = TestJsonHandler
    end
    subject{ @handler_class }

    should "use much-plugin" do
      assert_includes MuchPlugin, Deas::Json::ViewHandler
    end

    should "be a deas view handler" do
      assert_includes Deas::ViewHandler, subject
    end

    should "know its default status, headers and body values" do
      assert_equal 200,      subject::DEF_STATUS
      assert_equal Hash.new, subject::DEF_HEADERS
      assert_equal '{}',     subject::DEF_BODY
    end

  end

  class InitTests < UnitTests
    include Deas::ViewHandler::TestHelpers

    desc "when init"
    setup do
      @status  = Factory.integer
      @headers = { Factory.string => Factory.string }
      @body    = [Factory.text]

      @runner  = test_runner(@handler_class)
      @handler = @runner.handler
    end
    subject{ @runner }

    should "force its content type to :json" do
      assert_equal '.json', subject.content_type_args.extname
      exp = { 'charset' => 'utf-8' }
      assert_equal exp, subject.content_type_args.params
    end

    should "use all given args" do
      @handler.halt_args = [@status, @headers, @body]
      response = @runner.run

      assert_equal @status,  response.status
      assert_equal @headers, response.headers
      assert_equal @body,    response.body
    end

    should "should adhere to the rack spec for its body" do
      @handler.halt_args = [@status, @headers, @body.first]
      response = @runner.run

      assert_equal @status,  response.status
      assert_equal @headers, response.headers
      assert_equal @body,    response.body
    end

    should "default its status, headers and body if not provided" do
      response = @runner.run

      assert_equal DEF_STATUS,  response.status
      assert_equal DEF_HEADERS, response.headers
      assert_equal [DEF_BODY],  response.body
    end

    should "default its headers and body if not provided" do
      @handler.halt_args = [@status]
      response = @runner.run

      assert_equal @status,     response.status
      assert_equal DEF_HEADERS, response.headers
      assert_equal [DEF_BODY],  response.body
    end

    should "default its status and body if not provided" do
      @handler.halt_args = [@headers]
      response = @runner.run

      assert_equal DEF_STATUS, response.status
      assert_equal @headers,   response.headers
      assert_equal [DEF_BODY], response.body
    end

    should "default its status and headers if not provided" do
      @handler.halt_args = [@body]
      response = @runner.run

      assert_equal DEF_STATUS,  response.status
      assert_equal DEF_HEADERS, response.headers
      assert_equal @body,       response.body
    end

    should "default its status if not provided" do
      @handler.halt_args = [@headers, @body]
      response = @runner.run

      assert_equal DEF_STATUS, response.status
      assert_equal @headers,   response.headers
      assert_equal @body,      response.body
    end

    should "default its headers if not provided" do
      @handler.halt_args = [@status, @body]
      response = @runner.run

      assert_equal @status,     response.status
      assert_equal DEF_HEADERS, response.headers
      assert_equal @body,       response.body
    end

    should "default its body if not provided" do
      @handler.halt_args = [@status, @headers, [nil, ''].sample]
      response = @runner.run

      assert_equal @status,    response.status
      assert_equal @headers,   response.headers
      assert_equal [DEF_BODY], response.body
    end

  end

  class TestJsonHandler
    include Deas::Json::ViewHandler

    attr_accessor :halt_args

    def run!; halt *(@halt_args || []).dup; end

  end

end
