RSpec.describe WarblesController, type: :controller do
  describe 'GET #index' do
    it 'renders warblers index' do
      get :index #this will send a mock request. 
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'brings up form to create new warble' do
      # subject is the WarblesController instance that 
      # is being created for this test
      allow(subject).to receive(:logged_in?).and_return(true)
      # whenever the WarblesController (subject) calls the method
      # logged_in?, automatically return true.
      get :new
      expect(response).to render_template(:new)
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

    let(:valid_params) { { warble: {body: 'lets go nets'} } }
    # warbles is only created with the body. 
    # the key of nothing is not going to be part of our strong_params
    # so it wont affect the request.
    let(:invalid_params) { { warble: {nothing: '???'} } }

    context 'with valid params' do
      it 'creates the warble' do
        post :create, params: valid_params
        # Warble.last because its the last one that was put in the db.
        expect(Warble.last.body).to eq('lets go nets')
      end
      it 'redirects to the warbles show page' do
        post :create, params: valid_params
        expect(response).to redirect_to(warble_url(Warble.last.id))
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
