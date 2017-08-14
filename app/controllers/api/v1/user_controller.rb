class Api::V1::UserController < ApplicationController
	before_action :check_user , only: [:show, :update, :destroy]

	def index
		render :json =>{status: "ok", data: User.all}
	end

	def create
		response={}
		@user= User.new(user_params)
		if @user.save
			send_conformation_email
			response= {status: "success" , message: "signup successfully.", data:@user}
		else
			response={status: "error", data: @user.errors.full_messages}
		end
		render :plain => response.to_json
	end

	def show
		response={}
		if @user.present?
			response= {status: "login successfully", data:  @user}
		else
			response={status: "errors", message: "No User found this id"}
		end
		render :json => response
		
	end

	def destroy
		if @user.present?
			@user.destroy
			render :json=>{status: "ok", message: "successfully deleted records."}
		else
			render :json => {status: "error", data: @user.errors.full_messages}
		end
		
	end

	def update
		if @user.present?
			if @user.update_attributes(user_param)
				render :json => {status: "ok", message: "Update successfully" , data: @user}
			else
				render :json=> {status: "error", message:"some error to update", data: @user.errors.full_messages}
			end
		else
			render :json=>{status: "error", message: " An error occured!"}
		end		
	end

	def confirm_email
		authenticate_token= params[:format]
		authenticate_token_digest=User.digest(authenticate_token)
		user=User.find_by(:confirmation_token=>authenticate_token_digest)
		if user.present? && user.confirmed_at.blank?
			user.update_columns(:confirmed_at=>Time.now)
			render :json => {status: "ok", message: "Email has been confirmed"}
		elsif user.present? && user.confirmed_at.present?
			render :json => {status: "ok", message: "Email has been already confirmed"}
			
		else
			render :json=> {status: "error", message: "Envalid  conformation Token "}
		end
		
	end
	

	private

	def user_params
		params.require(:user).permit(:first_name,:last_name,:email,
									:password,:contact_number,:password_confirmation)
    end
    def user_param
		params.require(:user).permit(:first_name,:last_name,:contact_number)
    end

    def send_conformation_email
		UserMailer.registration_confirmation(@user).deliver
		@user.update(:confirmation_token=>User.digest(@user.confirmation_token))
	end

	def check_user

		@user= User.find(params[:id])
		
	end
end
