class Admin::EmailAddressesController < ApplicationController
  before_action :set_email_address, only: [:show, :edit, :update, :destroy]

  # GET /admin/email_addresses
  # GET /admin/email_addresses.json
  def index
    @email_addresses = paged_search Admin::EmailAddress
  end

  # GET /admin/email_addresses/1
  # GET /admin/email_addresses/1.json
  def show
  end

  # GET /admin/email_addresses/new
  def new
    @email_address = Admin::EmailAddress.new
  end

  # GET /admin/email_addresses/1/edit
  def edit
  end

  # POST /admin/email_addresses
  # POST /admin/email_addresses.json
  def create
    @email_address = Admin::EmailAddress.new(email_address_params)

    respond_to do |format|
      if @email_address.save
        format.html { redirect_to @email_address, notice: 'Email address was successfully created.' }
        format.json { render :show, status: :created, location: @email_address }
      else
        format.html { render :new }
        format.json { render json: @email_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/email_addresses/1
  # PATCH/PUT /admin/email_addresses/1.json
  def update
    respond_to do |format|
      if @email_address.update(email_address_params)
        format.html { redirect_to @email_address, notice: 'Email address was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_address }
      else
        format.html { render :edit }
        format.json { render json: @email_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/email_addresses/1
  # DELETE /admin/email_addresses/1.json
  def destroy
    @email_address.destroy
    respond_to do |format|
      format.html { redirect_to admin_email_addresses_url, notice: 'Email address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_address
      @email_address = Admin::EmailAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_address_params
      params.require(:admin_email_address).permit(:email)
    end
end
