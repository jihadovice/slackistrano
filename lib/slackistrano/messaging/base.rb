require 'forwardable'
require_relative 'helpers'

module Slackistrano
  module Messaging
    class Base

      include Helpers

      extend Forwardable
      def_delegators :env, :fetch

      attr_reader :team, :token, :webhook

      def initialize(env: nil, team: nil, channel: nil, token: nil, webhook: nil, run: true)
        @env = env
        @team = team
        @channel = channel
        @token = token
        @webhook = webhook
        @run = run
      end

      def icon_url
        'https://raw.githubusercontent.com/phallstrom/slackistrano/master/slackistrano.png'
      end

      def icon_emoji
        nil
      end

      def username
        'Slackistrano'
      end

      def deployer
        ENV['USER'] || ENV['USERNAME']
      end

      def message_for_updating
        {
          text: "#{deployer} has started deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def message_for_reverting
        {
          text: "#{deployer} has started rolling back branch #{branch} of #{application} to #{stage}"
        }
      end

      def message_for_updated
        {
          text: "#{deployer} has finished deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def message_for_reverted
        {
          text: "#{deployer} has finished rolling back branch of #{application} to #{stage}"
        }
      end

      def message_for_failed
        {
          text: "#{deployer} has failed to #{deploying? ? 'deploy' : 'rollback'} branch #{branch} of #{application} to #{stage}"
        }
      end

      def channels_for(action)
        @channel
      end

      def should_run_for?(action)
        @run
      end

      ################################################################################

      def message_for(action)
        method = "message_for_#{action}"
        respond_to?(method) && send(method)
      end

      def via_slackbot?
        @webhook.nil?
      end

    end
  end
end

require_relative 'default'
require_relative 'deprecated'
