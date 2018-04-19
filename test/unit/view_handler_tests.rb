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

    should "override the default status and body values" do
      assert_equal 200,    subject.default_status
      assert_equal ['{}'], subject.default_body
    end

  end

  class InitTests < UnitTests
    include Deas::ViewHandler::TestHelpers

    desc "when init"
    setup do
      @runner  = test_runner(@handler_class)
      @handler = @runner.handler
    end
    subject{ @runner }

    should "force its content type to :json" do
      assert_equal '.json', subject.content_type_args.extname
      exp = { 'charset' => 'utf-8' }
      assert_equal exp, subject.content_type_args.params
    end

  end

end
