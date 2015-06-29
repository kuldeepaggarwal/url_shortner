require 'rails_helper'

RSpec.describe TinyUrlsController, type: :controller do
  describe 'GET #new' do
    context 'when user logged in' do
      login_user
      before { get :new }

      it 'redirects to dashboard page' do
        expect(response).to redirect_to(controller.send(:after_sign_in_path_for, controller.current_user))
      end

      it 'returns 302 status code' do
        expect(response.status).to eq(302)
      end
    end

    context 'when user not logged in' do
      before { get :new }

      it 'renders new page' do
        expect(response).to render_template(:new)
      end

      it 'returns 200 status code' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #create' do
    context 'when logged in' do
      login_user

      context 'when valid details' do
        let(:params) { { tiny_url: { url: Faker::Internet.url } } }

        it 'renders tiny_url partial' do
          expect(controller.current_user.tiny_urls(true)).to be_empty
          post :create, params
          expect(controller.current_user.tiny_urls(true)).to be_present
          expect(response).to render_template(partial: 'tiny_urls/_tiny_url')
        end

        it 'returns 200 status code' do
          post :create, params
          expect(response.status).to eq(200)
        end
      end

      context 'when invalid details' do
        let(:params) { { tiny_url: { url: '' } } }

        it 'renders tiny_url partial' do
          expect(controller.current_user.tiny_urls(true)).to be_empty
          post :create, params
          expect(controller.current_user.tiny_urls(true)).to be_empty
          expect(response).to render_template(partial: 'tiny_urls/_form')
        end

        it 'returns 422 status code' do
          post :create, params
          expect(response.status).to eq(422)
        end
      end
    end

    context 'when not logged in' do
      context 'when valid details' do
        let(:params) { { tiny_url: { url: Faker::Internet.url } } }

        it 'renders tiny_url partial' do
          expect(TinyUrl.all).to be_empty
          post :create, params
          created_tiny_url = TinyUrl.last
          expect(created_tiny_url.url).to eq(params[:tiny_url][:url])
          expect(created_tiny_url.owner).to be_nil
          expect(response).to render_template(partial: 'tiny_urls/_tiny_url')
        end

        it 'returns 200 status code' do
          post :create, params
          expect(response.status).to eq(200)
        end
      end

      context 'when invalid details' do
        let(:params) { { tiny_url: { url: '' } } }

        it 'renders tiny_url partial' do
          expect(TinyUrl.all).to be_empty
          post :create, params
          expect(TinyUrl.all).to be_empty
          expect(response).to render_template(partial: 'tiny_urls/_form')
        end

        it 'returns 422 status code' do
          post :create, params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'GET #translate' do
    context 'when slug found' do
      let(:tiny_url) { FactoryGirl.create(:tiny_url) }
      before { get :translate, slug: tiny_url.slug }

      it 'redirects to actual url' do
        expect(response).to redirect_to(tiny_url.url)
      end

      it 'sets response status code to 301' do
        expect(response.status).to eq(301)
      end
    end

    context 'when slug not found' do
      before { get :translate, slug: Faker::Internet.url }

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets flash alert message' do
        expect(flash[:alert]).to eq('No url found')
      end
    end
  end
end
