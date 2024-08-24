class HomeController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @forms = Form.all
    @departments = Department.all
    @announcement = Announcement.find(1)

    redirect_to home_validate_path
  end

  def app_profile
    @user = User.find(current_user.id)
    if @user.tab_no == 1
      @response = Response.new
      @tab= Tab.find(@user.tab_no)
    else
      @response = Response.find(params[:res_id])
      @user.nav_tab_no = params[:nav_tab_no]
      @tab= Tab.find(@user.nav_tab_no)
      @user.save
    end
    @questions = Question.all
  end

  def instruction
    @user = current_user
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

  def deadline

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
