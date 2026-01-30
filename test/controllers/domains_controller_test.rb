# frozen_string_literal: true

require 'test_helper'

class DomainsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get domains_show_url
    assert_response :success
  end
end
