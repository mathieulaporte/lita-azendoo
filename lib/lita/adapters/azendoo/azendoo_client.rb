require 'Faye'
require 'Net/HTTP'
require 'json'
require 'eventmachine'
require 'em-synchrony'
puts 'LOADED !'
module AzendooClient
  class Push
    attr_reader :push_token

    def initialize(push_token)
      @push_token = push_token
    end

    def outgoing(message, callback)
      message['ext'] ||= {}
      message['ext']['user_token'] = push_token
      callback.call(message)
    end
  end

  class API
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def me
      uri = URI('https://app.azendoo.com/users/me.json')
      fetch(uri)
    end

    def user_id
      me['id']
    end

    def push_token
      me['push_token']
    end

    def fetch_message(workspace_id, thread_id, message_id)
      uri = URI("https://app.azendoo.com/workspaces/#{workspace_id}/direct_messages/#{thread_id}")
      thread  = parse_thread(fetch(uri))
      message = thread['data']['messages'].find { |m| m['id'] == message_id }
      message['context'] = { 'workspace_id' => workspace_id, 'thread_id' => thread_id }
      message
    end

    def parse_thread(hash)
      hash['data']['messages'].each do |message|
        message['user'] = hash['included'].find { |includes| includes['type'] == 'users' && includes['id'] == message['user'] }
      end
      hash
    end

    def send_message(workspace_id, thread_id, text)
      message = { data: { body: text, medias: [] } }.to_json
      uri = URI("https://app.azendoo.com/workspaces/#{workspace_id}/direct_messages/#{thread_id}/messages")
      post(uri, message)
    end

    def on_message
      push = AzendooClient::Push.new(push_token)
      EM.synchrony do
        client  = Faye::Client.new('https://app.azendoo.com:4242/colossus/')
        client.add_extension(push)
        client.subscribe("/users/#{user_id}") do |message|
          if message['data']['event'] == 'new_direct_message'
            message = fetch_message(
              message['data']['workspace_id'],
              message['data']['thread_id'],
              message['data']['id']
            )
            next if message['user'] == user_id
            yield message
          end
        end
      end
    end

    private

    def fetch(uri)
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Token token=\"#{api_key}\""
      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(request)
      }
      JSON.load(res.body)
    end

    def post(uri, data)
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Token token=\"#{api_key}\""
      request.body = data
      request.content_type = 'application/json'
      # request.set_form_data(data)
      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(request)
      }
      JSON.load(res.body)
    end
  end
end
