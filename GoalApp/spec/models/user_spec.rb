require 'rails_helper'

RSpec.describe User, type: :model do

    it {should validate_presence_of(:name)}
    it {should have_many(:goals)}
    it {should validate_presence_of(:session_token) }
    it {should validate_uniqueness_of(:session_token)}
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }

    describe 'uniqueness' do
        before(:each) do
            create(:user)
        end
    end

    describe 'is_password?' do
        let!(:user) {create(:user)}

        context 'with valid password' do 
            it 'should return true' do
                expect(user.is_password?('starwars')).to be (true)
            end
        end

        context 'with invalid password' do 
            it 'should return false' do
                expect(user.is_password?('startrek')).to be(false)
            end
        end 


    end

end