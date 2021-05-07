class Admin::CreditsController < AdminController

  def index
    @credits = Credit.where(nil)
    @credits = @credits
  end

  def show
    @credit = Credit.find params[:id]
  end

  def new
    @credit = Credit.new
  end

  def create
    @credit = Credit.new credit_params

    if @credit.save
      flash[:notice] = 'Type item created'
      redirect_to admin_credits_path
    else
      flash.now[:warning] = @credit.errors.full_messages
      render :action => :new
    end
  end

  def update

    @credit = Credit.find params[:id]

    if @credit.update credit_params
      flash[:notice] = 'Type item has been updated'
      redirect_to admin_credit_path(@credit)
    else
      flash.now[:warning] = @credit.errors.full_messages
      render :action => :show
    end
  end

  def destroy
    @credit = Credit.find params[:id]
    @credit.destroy
    flash[:notice] = 'Type item has been deleted'
    redirect_to admin_credits_path
  end

  def rank
    pp = params[:credits]
    Credit.update(pp.keys, pp.values)
    flash[:notice] = 'Type items have been updated'
    redirect_to admin_credits_path
  end

  private

  def credit_params
    params.require(:credit).permit(
      :name,
      :url,
    )
  end
end
