 class ApplicationController < ActionController::API
 	#attr_reader :current_user

	def authenticate_user
		debugger
		 user = User.find_by(email: params[:email])
	  if user && user.authenticate(params[:password])
		render json: payload(user)
		else
		render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
		end
	end

  	protected
	def authenticate_request!
		unless user_id_in_token?
		render json: { errors: ['Not Authenticated'] }, status: :unauthorized
		return
		end
		@current_user = User.find(auth_token[:user_id])
		rescue JWT::VerificationError, JWT::DecodeError
		render json: { errors: ['Not Authenticated'] }, status: :unauthorized
	end

  	private
  	def http_token
  		debugger
		@http_token ||= if request.headers['Authorization'].present?
			request.headers['Authorization'].split(' ').last
   		 end
  	end

  	def auth_token
  		debugger
    	@auth_token ||= JsonWebToken.decode(http_token)
  	end

  	def user_id_in_token?
  	  http_token && auth_token && auth_token[:user_id].to_i
  	end
  	
  	def payload(user)
  		debugger
    return nil unless user and user.id
    {

      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email}
    }
  end
end