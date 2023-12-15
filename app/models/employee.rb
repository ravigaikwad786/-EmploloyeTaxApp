class Employee < ApplicationRecord
    validates :employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary, presence: true
end
