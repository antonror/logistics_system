require 'rails_helper'

RSpec.describe MoteefeService do
  context 'should inherit from ApplicationService' do
    it 'should be an instance of ApplicationService' do
      expect(described_class).to be < ApplicationService
    end
  end
end
