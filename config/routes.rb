Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	#root 'api/v1/user#index'
	namespace :api do
	  	namespace :v1 do
	  		resources :user do
	  			collection do 
	  				get :confirm_email
	  			end
	  		end
	 	end
	end
end
