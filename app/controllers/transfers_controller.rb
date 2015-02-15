class TransfersController < ApplicationController
  before_action :check_validation
  before_action(:set_transfer,
                only: [:show, :edit, :update, :destroy,
                       :off_dashboard])

  # GET /transfers
  # GET /transfers.json
  def index
    @transfers = Transfer.all
  end

  # GET /transfers/recent
  # GET /transfers/recent.json
  def recent
    @transfers = Transfer.recent
    @user = User.find(session[:user_id])
    render :layout=>"layouts/common"
  end

  # GET /transfers/1
  # GET /transfers/1.json
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
  end

  # GET /transfers/1/edit
  def edit
  end

  # POST /transfers
  # POST /transfers.json
  def create
    unless @current_user.can_transfer_money?
      redirect_to vendor_declined_path
      return
    end

    @transfer = Transfer.new(transfer_params)

    respond_to do |format|
      if @transfer.save
        @transfer.initiate_payment
        notice = "Money sent to #{@transfer.recipient.first_name}"
        format.html { redirect_to(dashboard_user_path(@transfer.user),
                                  :notice=>notice)}
        format.json { render :show, status: :created, location: @transfer }
      else
        format.html do
          a = @transfer.attributes
          a[:error_messages] = @transfer.errors.messages
          flash[:transfer] = Marshal.dump(a)
          redirect_to dashboard_user_path(@transfer.user_id)
        end
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfers/1
  # PATCH/PUT /transfers/1.json
  def update
    respond_to do |format|
      if @transfer.update(transfer_params)
        format.html { redirect_to @transfer, notice: 'Transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1
  # DELETE /transfers/1.json
  def destroy
    @transfer.destroy
    respond_to do |format|
      format.html { redirect_to transfers_url, notice: 'Transfer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def off_dashboard
    @transfer.update_attribute(:on_dashboard, false)
    respond_to do |format|
      format.html { redirect_to dashboard_user_path(@current_user) }
      format.js
    end
  end

  def complete
    state_change do
      @transfer.update_complete session[:user_id]
    end
  end

  def accept
    state_change do
      @transfer.update_accept session[:user_id]
    end
  end

  def cancel
    state_change do
      @transfer.update_cancel session[:user_id]
    end
  end

  def fail
    state_change do
      @transfer.update_fail session[:user_id]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_params
      params.
        require(:transfer).
        permit(:user_id, :recipient_id, :amount, :note, :kind, :state, :image)
    end

  def state_change
    Transfer.transaction do
      @transfer = Transfer.find(params[:id])
      yield
    end
    respond_to do |format|
      format.html { redirect_to dashboard_user_path(@current_user) }
      format.js { render :update }
    end
  end

end
