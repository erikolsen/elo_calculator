class CreateFacebookAccount < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.string :image_url
      t.string :email
      t.datetime :oauth_expires_at
    end
  end
end
