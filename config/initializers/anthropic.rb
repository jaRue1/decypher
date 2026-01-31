# frozen_string_literal: true

# Anthropic API configuration
# The client is initialized with the API key when needed in services
# API key is stored in Rails credentials or environment variable

Rails.application.config.anthropic_api_key = Rails.application.credentials.dig(:anthropic, :api_key) || ENV['ANTHROPIC_API_KEY']
