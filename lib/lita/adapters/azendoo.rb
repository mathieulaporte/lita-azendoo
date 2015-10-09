require 'lita/adapters/azendoo/connector'
require 'lita/adapters/azendoo/azendoo_client'
module Lita
  module Adapters
    class Azendoo < Adapter
      config :api_key, type: String, required: true
      attr_reader :connector

      def initialize(robot)
        super(robot)
        @connector = Connector.new(robot, config.api_key)
      end

      def run
        robot.trigger(:connected)
        connector.connect
      rescue Interrupt
        shut_down
      end

      def shut_down
      end

      def send_messages(target, strings)
        puts target.inspect
        connector.messages(target, strings)
      end

      Lita.register_adapter(:azendoo, self)
    end
  end
end
