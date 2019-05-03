class User < ApplicationRecord

    validates :name, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password

    after_initialize :ensure_session_token

    has_many :goals,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Goal

    def self.find_by_credentials(name, password)
        user = User.find(name: name)

        return nil unless user && user.is_password?(password)
        user
    end
    
    def password=(password)
       @password = password
        self.password_digest = BCrypt::Password.create(password)
    end
    
    def is_password?(password)
        encrypted_password = BCrypt::Password.new(self.password_digest)
        encrypted_password.is_password?(password)
    end

    def reset_session_token! 
        self.update!(session_token: self.class.generate_session_token)
        self.session_token
    end

    private
    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end


end