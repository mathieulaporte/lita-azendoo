module Lita
  module Adapters
    class Azendoo < Adapter
      class Connector
        attr_reader :robot, :azendoo

        def initialize(robot, api_key)
          @robot = robot
          @azendoo = ::AzendooClient::API.new(api_key)
        end

        def connect
          azendoo.on_message do |message|
            user    = User.new(message['user']['id'], name: message['user']['name'])
            source  = Source.new(user: user, room: "#{message['context']['workspace_id']}/#{message['context']['thread_id']}")
            message = Message.new(robot, message['body'], source)
            robot.receive(message)
          end
        end

        def messages(target, strings)
          workspace_id, thread_id = target.room.split('/')
          strings.each do |message|
            azendoo.send_message(
              workspace_id,
              thread_id,
              message
            )
          end
        end
      end
    end
  end
end
