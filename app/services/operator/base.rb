# frozen_string_literal: true

module Operator
  class Base
    class ApiError < StandardError; end
    class InvalidResponseError < StandardError; end

    TIMEOUT = 60

    def initialize
      @client = Anthropic::Client.new(api_key: api_key)
    end

    protected

    def call_api(system_prompt:, user_prompt:, max_tokens: 4096)
      response = @client.messages.create(
        model: "claude-sonnet-4-20250514",
        max_tokens: max_tokens,
        system: system_prompt,
        messages: [ { role: "user", content: user_prompt } ]
      )

      extract_content(response)
    rescue Anthropic::Error => e
      Rails.logger.error("Anthropic API error: #{e.message}")
      raise ApiError, "Failed to communicate with AI: #{e.message}"
    end

    def parse_json_response(content)
      # Extract JSON from markdown code blocks if present
      json_content = content.match(/```(?:json)?\s*([\s\S]*?)```/)&.[](1) || content

      JSON.parse(json_content.strip)
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parse error: #{e.message}, content: #{content}")
      raise InvalidResponseError, "Invalid response format from AI"
    end

    private

    def api_key
      Rails.application.config.anthropic_api_key
    end

    def extract_content(response)
      response.content&.first&.text || ""
    end
  end
end
