class UsersController < ApplicationController
  before_action :check_validation, :except=>[:new,
                                             :create,
                                             :pending_validation,
                                             :resend_validation,
                                             :validate,
                                             :forgot_password,
                                             :temp_password]
  before_action :set_user, only: [:show, :edit, :update,
                                  :dashboard, :dashboard_transfer_list,
                                  :pending_validation,
                                  :resend_validation,
                                  :update_password,
                                  :change_password]
  before_action :ensure_correct_user, :only=>[:edit, :update,
                                              :dashboard,
                                              :dashboard_transfer_list]
  before_action(:check_temporary_password,
                :except=>[:change_password,
                          :new,
                          :create,
                          :pending_validation,
                          :resend_validation,
                          :validate,
                          :forgot_password,
                          :update_password,
                          :temp_password])


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session.clear
        @user.signin session
        UserMailer.validation(@user).deliver
        format.html { redirect_to dashboard_user_path(@user), notice: 'Welcome to Buck Up!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    @ok = false
    if @user.password_credential.authenticate? params[:user][:current_password]
      User.transaction do
        @user.password_credential.destroy!
        @credential = @user.credentials.create(password_params)
        if @credential.persisted?
          @notice = "Password changed"
          @ok = true
        else
          @notice = @credential.errors.values.join("<br/>").html_safe
          raise ActiveRecord::Rollback
        end
      end
    else
      @notice = "Current password does not match, try again"
    end
  end

  def change_password
  end

  def dashboard
  end

  def dashboard_transfer_list
    @transfers = Transfer.
      involving(@user).
      where(:on_dashboard=>true).
      where(["comment_at > ?", Time.zone.parse(params[:timestamp])]).
      order(:created_at)
    respond_to do |format|
      format.js
    end
  end

  def pending_validation
  end

  def resend_validation
    raise "expecting validation" unless @user.validation
    UserMailer.validation(@user).deliver
  end

  def new_validation
    @user.validation.delete
    @user.create_validation
    UserMailer.validation(@user).deliver
    redirect_to pending_validation_path(@user)
  end

  def validate
    @validation = Validation.find_by(:key=>params[:key])
    if @validation
      @user = @validation.user
      if Time.now < @validation.expires_at
        @validation.delete
        session.clear
        @user.signin session
        redirect_to dashboard_user_path(@user)
      end
    else
      redirect_to sessions_new_path
    end
  end

  def forgot_password
  end

  def temp_password
    @user = User.find_by(:email=>params[:email])
    if @user
      password = @user.create_temporary_password
      UserMailer.temp_password(@user, password).deliver
    else
      flash[:notice] = "Your email does not match an existing user."
      redirect_to forgot_password_users_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.
        require(:user).
        permit(:first_name,
               :last_name,
               :email,
               :time_zone,
               :avatar,
               :credentials_attributes=>[:password, :password_confirmation])
    end
    def password_params
      params.
        require(:user).
        require(:credentials_attributes).
        require("0").
        permit(:password, :password_confirmation)
    end

    def ensure_correct_user
      unless @user.id == session[:user_id]
        redirect_to user_path(session[:user_id])
      end
    end
end
