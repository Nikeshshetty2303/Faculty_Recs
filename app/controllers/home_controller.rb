class HomeController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @forms = Form.all
    @departments = Department.all
  end

  def app_profile
    @user = User.find(current_user.id)
    @response = Response.new
    @questions = Question.all
    tab_no = current_user.tab_no
    @tab= Tab.find(@user.tab_no)
  end

  def edit_app_profile
    @user = User.find(current_user.id)
    @response = Response.where(id: @res_id)
    @questions = Question.all
    tab_no = current_user.tab_no
    @tab= Tab.find(@user.tab_no)
  end

  def validate
    @user = User.find(current_user.id)
    @response = Response.all
  end

  # respond_to do |format|
  #     format.html
  #     format.pdf do
  #       render pdf: 'Pet Medical Report', # file name
  #              template: 'home/pet_report1.html.erb',
  #              layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
  #              disposition: 'inline',
  #             margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
  #     end
  #   end
end
