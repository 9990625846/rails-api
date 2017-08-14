class User < ApplicationRecord
	#attr_accessor :password
	before_create :authentication_token

    validates_presence_of :email,:contact_number
    validates :first_name,  :last_name,  presence: :true
	validates :email,presence: :true,uniqueness: true
	validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i
	validates :contact_number, :numericality => {:only_integer => true} ,:length=>{maximum: 10}
	has_secure_password
	#before_create { self.email = email.downcase }
   	validates :password,  presence: true, length: { minimum: 6 },if: :password
    validates_presence_of :password,  :on => :create
	def authentication_token
		  self.confirmation_token= SecureRandom.urlsafe_base64
	end

	def self.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end
end


