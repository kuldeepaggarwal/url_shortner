require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:tiny_urls).dependent(:destroy) }
  end

  describe 'Instance Methods' do
    describe '#build_tiny_url' do
      it 'builds and returns a new TinyUrl object for user' do
        expect(subject.tiny_urls).to be_empty
        object = subject.build_tiny_url
        expect(object).to be_an_instance_of(TinyUrl)
        expect(subject.tiny_urls).to be_present
      end
    end
  end
end
