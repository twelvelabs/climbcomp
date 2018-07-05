class CreateUserIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_identities do |t|
      t.integer :user_id,         null: false
      t.string  :sub,             null: false
      t.string  :email,           null: false
      t.boolean :email_verified,  null: false, default: false
      t.string  :name
      t.string  :nickname
      t.string  :picture
      t.timestamps
    end

    add_index :user_identities, :user_id
    add_index :user_identities, :sub
    add_index :user_identities, :email

    add_foreign_key :user_identities, :users, column: :user_id, on_delete: :cascade
  end
end
