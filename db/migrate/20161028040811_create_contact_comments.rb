class CreateContactComments < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_comments, id: :uuid do |t|
      t.string :name
      t.string :email
      t.text :message
      t.boolean :replied, default: false

      t.timestamps null:false
    end
  end
end
