class UsersController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def index
        @users = User.all.includes(:name)
        render :index
    end

    def create
        @user = User.new
        if @user.save 
            redirect_to user_url(@user)
        else
            flash[:errors] = @user.errors.full_messages
        end
    end


    def destroy 
        
    end

end