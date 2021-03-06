# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module Middleman
  module Robots
    module Generators
      # Block
      #
      # Generating Block in robots.txt
      class Block
        attr_accessor :rule

        def initialize(rule)
          @rule = rule
        end

        def text
          [
            user_agent,
            disallow,
            allow
          ].compact.join("\n")
        end

        private

        def user_agent
          user_agent = rule[:user_agent].presence || rule['user-agent'].presence || '*'
          if !user_agent.is_a?(String) && !user_agent.nil?
            raise ArgumentError, '`user_agent` or `user-agent` option must be String or nil'
          end

          "User-Agent: #{user_agent}"
        end

        def disallow
          return nil if rule[:disallow].nil?
          unless rule[:disallow].is_a? Array
            raise ArgumentError, '`disallow` option must be Array or nil'
          end

          rule[:disallow].map { |path| "Disallow: #{File.join('/', path)}" }
        end

        def allow
          return nil if rule[:allow].nil?
          raise ArgumentError, '`allow` option must be Array or nil' unless rule[:allow].is_a? Array

          rule[:allow].map { |path| "Allow: #{File.join('/', path)}" }
        end
      end
    end
  end
end
