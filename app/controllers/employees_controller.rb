class EmployeesController < ApplicationController
    before_action :set_employee, only: [:show, :update, :destroy]

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        render json: @employee, status: :created
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    end
  
    def tax_deductions
        employees = Employee.all
        deductions = employees.map { |employee| calculate_tax(employee) }
    
        render json: deductions
      end
    
      private
    
      def set_employee
        @employee = Employee.find(params[:id])
      end
    
      def employee_params
        params.require(:employee).permit(:employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary)
      end
    
      def calculate_tax(employee)
        start_date = employee.doj.beginning_of_month
        end_date = Date.current.end_of_month
        months_worked = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1
    
        total_salary = employee.salary * months_worked
        loss_of_pay = (employee.salary / 30.0) * (start_date.day - 1)
        annual_salary = total_salary - loss_of_pay
    
        tax = calculate_income_tax(annual_salary)
        cess = annual_salary > 2500000 ? annual_salary * 0.02 : 0
    
        {
          employee_code: employee.employee_id,
          first_name: employee.first_name,
          last_name: employee.last_name,
          yearly_salary: annual_salary,
          tax_amount: tax,
          cess_amount: cess
        }
      end
    
      def calculate_income_tax(annual_salary)
        case annual_salary
        when 0..250000
          0
        when 250001..500000
          (annual_salary - 250000) * 0.05
        when 500001..1000000
          250000 * 0.05 + (annual_salary - 500000) * 0.1
        else
          250000 * 0.05 + 500000 * 0.1 + (annual_salary - 1000000) * 0.2
        end
      end
  
end
