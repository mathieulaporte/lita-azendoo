module Lita
  module Adapters
    class Twitter < Adapter
      class Connector
        def initialize(robot)
          @robot = robot
          @azendoo = Azendoo::API.new(config.api_key)
        end

        def connect
          azendoo.on_message do |message|
            user    = User.new(message['user']['id'], name: message['name'])
            source  = Source.new(user: user, room: message['context'])
            message = Message.new(robot, text, source)
            robot.receive(message)
          end
        end

        def messages(target, strings)
          strings.each do |message|
            azendoo.send_message(
              target['workspace_id'],
              target['thread_id'],
              message
            )
          end
        end
      end
    end
  end
end
