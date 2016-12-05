class Admin::PressController < AdminController

  before_action :require_admin

  # GET /admin/press_list
  # GET /admin/press_list.json
  def clear
    Journalist.destroy_all
    redirect_to :back
  end
  def index
    @title = 'Press List'
    @press_list = Journalist.all

    respond_to do |format|
      format.csv { send_data @press_list.to_csv, filename: "press_list-#{Date.today}.csv" }
      format.html
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def require_admin
      unless user_signed_in? && current_user.admin
        flash[:error] = "You aren't authorized to manage users"
        redirect_to root_path
      end
    end
end


