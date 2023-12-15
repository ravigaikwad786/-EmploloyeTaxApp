class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.integer :employee_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :phone_numbers
      t.date :doj
      t.decimal :salary

      t.timestamps
    end
  end
end
