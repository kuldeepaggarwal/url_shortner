require 'rails_helper'

RSpec.describe GuestUser, type: :model do
  describe 'Instance Methods' do
    describe '#build_tiny_url' do
      it 'returns a new object of TinyUrl' do
        object = subject.build_tiny_url
        expect(object).to be_an_instance_of(TinyUrl)
        expect(object).to be_new_record
      end
    end
  end
end
