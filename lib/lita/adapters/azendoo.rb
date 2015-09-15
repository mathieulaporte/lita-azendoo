module Lita
  module Adapters
    class Azendoo < Adapter
      config :api_key, type: String, required: true

      def initialize(robot)
        super(robot)
        @azendoo = Azendoo::API.new(config.api_key)
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
