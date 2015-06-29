require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#uri_path' do
    it 'returns the path of url' do
      expect(helper.uri_path('http://google.com')).to eq('google.com')
      expect(helper.uri_path('https://google.com')).to eq('google.com')
    end
  end
end
