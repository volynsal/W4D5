require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'renders users index' do
      get :index #this will send a mock request. 
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'brings up form to create new user' do
      # subject is the WarblesController instance that 
      # is being created for this test
      allow(subject).to receive(:logged_in?).and_return(true)
      # whenever the WarblesController (subject) calls the method
      # logged_in?, automatically return true.
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    before(:each) do
    # whenever the instance of WarbleController calls the method
    # current_user and returns the users author 
    # (the user we created in the let!)
      allow(subject).to receive(:current_user).and_return(user.author)
      # giving the request the correct params
      delete :destroy, params: { id: user.id } 
    end
    
    it 'should delete the user' do
      # exist is an active record method. just checks in the users table
      # if the specific id exists in the db.
      expect(Warble.exists?(user.id)).to be(false)
    end

    it 'should redirect us to the user index' do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(users_url)
    end

  end

  describe 'POST #create' do
    before(:each) do
      # testing db won't keep info between tests. 
      # Only saves things for the block. when we leave the block, 
      # the db gets reset to what the outer block had.
      create(:user)
      allow(subject).to receive(:current_user).and_return(User.last)
    end

    let(:valid_params) { { user: {body: 'lets go nets'} } }
    # users is only created with the body. 
    # the key of nothing is not going to be part of our strong_params
    # so it wont affect the request.
    let(:invalid_params) { { user: {nothing: '???'} } }

    context 'with valid params' do
      it 'creates the user' do
        post :create, params: valid_params
        # Warble.last because its the last one that was put in the db.
        expect(Warble.last.body).to eq('lets go nets')
      end
      it 'redirects to the users show page' do
        post :create, params: valid_params
        expect(response).to redirect_to(user_url(Warble.last.id))
      end
    end

    context 'invalid params' do
      before(:each) do 
        post :create, params: invalid_params
      end
      it 'should stay on page despite error' do
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
      it 'adds errors to the flash errors cookie' do
        expect(flash[:errors]).to be_present
      end
    end
  end
end