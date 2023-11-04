class HomeController < ApplicationController
  def index
    @user = User.find(current_user.id)
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
