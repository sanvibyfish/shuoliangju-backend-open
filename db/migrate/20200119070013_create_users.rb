class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :cellphone
      t.string :avatar

      t.timestamps
    end


    add_index :users, [:cellphone,:password_digest], unique: true

  end
end
