# frozen_string_literal: true

require 'spec_helper'

describe 'peers::resource_by_param' do
  # please note that these tests are examples only
  # you will need to replace the params and return value
  # with your expectations
  # it { is_expected.to run.with_params(2).and_return(4) }
  # it { is_expected.to run.with_params(4).and_return(8) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
