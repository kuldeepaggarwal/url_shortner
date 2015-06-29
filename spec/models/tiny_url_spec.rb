require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  describe 'Constants' do
    it 'has DEFAULT_PROTOCOL' do
      expect(TinyUrl::DEFAULT_PROTOCOL).to eq('http://')
    end

    it 'has PROTOCOL_REGEXP' do
      expect(TinyUrl::PROTOCOL_REGEXP).to eq(/\Ahttps?:\/\//i)
    end
  end

  describe 'Configurations' do
    it 'has slug length of 5' do
      expect(TinyUrl.slug_length).to eq(5)
    end

    it 'has only alphanumeric characters set' do
      expect(TinyUrl.character_set).to eq(('a'..'z').to_a + (0..9).to_a)
    end

    it 'has 10 max retries' do
      expect(TinyUrl.max_retries).to eq(10)
    end
  end

  describe 'Associations' do
    it { should belong_to(:owner) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:url) }
    it { should allow_value('http://google.com', 'https://google.com').for(:url) }
    it { should_not allow_value('google.com', 'https://google1,.com').for(:url) }

    describe 'owner' do
      context 'when any owner_ attribute is present' do
        before do
          subject.owner_type = 'User'
          subject.valid?
        end

        it { expect(subject.errors[:owner]).to eq(["can't be blank"]) }
      end

      context 'when both owner_ attribute is absent' do
        it { should_not validate_presence_of(:owner) }
      end
    end
  end

  describe 'Callbacks' do
    describe 'before_create' do
      let(:subject) { FactoryGirl.build(:tiny_url) }

      it 'sets unique slug' do
        expect(subject.slug).to be_nil
        subject.save!
        expect(subject.slug).to_not be_nil
      end

      it 'raises error if not found unique slug after max_retries' do
        original_max_retries = TinyUrl.max_retries
        begin
          TinyUrl.max_retries = 1
          tiny_url = FactoryGirl.create(:tiny_url)
          allow_any_instance_of(TinyUrl).to receive(:generate_key).and_return(tiny_url.slug)
          expect { subject.save }.to raise_error(RuntimeError)
        ensure
          TinyUrl.max_retries = original_max_retries
        end
      end

      it 'normalize url' do
        subject.url = 'http://google.com/'
        subject.save!
        expect(subject.url).to eq('http://google.com')
        subject.url = 'http://auer.info/laurie.hoppe'
        subject.save!
        expect(subject.url).to eq('http://auer.info/laurie.hoppe')
      end
    end

    describe 'before_save' do
      let(:subject) { FactoryGirl.create(:tiny_url) }

      it 'normalize url' do
        subject.url = 'http://google.com/'
        subject.save!
        expect(subject.url).to eq('http://google.com')
        subject.url = 'http://auer.info/laurie.hoppe'
        subject.save!
        expect(subject.url).to eq('http://auer.info/laurie.hoppe')
      end
    end
  end

  describe 'Scopes' do
    describe '.ordered' do
      let(:first_tiny_url) { FactoryGirl.create(:tiny_url) }
      let(:second_tiny_url) { FactoryGirl.create(:tiny_url) }

      before do
        first_tiny_url
        sleep(1)
        second_tiny_url
      end

      it 'returns objects in chronological order' do
        expect(TinyUrl.ordered.to_a).to eq([second_tiny_url, first_tiny_url])
      end
    end
  end
end
