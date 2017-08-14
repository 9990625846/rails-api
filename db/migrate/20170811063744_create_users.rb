class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.string :first_name
    	t.string :last_name
    	t.string :email , unique: true
    	t.integer :contact_number,  unique: true ,limit: 10
    	t.string :password_digest, null: false, default: ""
    	t.string  :confirmation_token, unique: true
    	t.datetime :confirmed_at
      	t.timestamps
    end
  end
end