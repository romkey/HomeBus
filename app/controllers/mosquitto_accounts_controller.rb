class MosquittoAccountsController < ApplicationController
  before_action :set_mosquitto_account, only: [:show, :edit, :update, :destroy]

  # GET /mosquitto_accounts
  # GET /mosquitto_accounts.json
  def index
    @mosquitto_accounts = MosquittoAccount.all
  end

  # GET /mosquitto_accounts/1
  # GET /mosquitto_accounts/1.json
  def show
  end

  # GET /mosquitto_accounts/new
  def new
    @mosquitto_account = MosquittoAccount.new
  end

  # GET /mosquitto_accounts/1/edit
  def edit
  end

  # POST /mosquitto_accounts
  # POST /mosquitto_accounts.json
  def create
    @mosquitto_account = MosquittoAccount.new(mosquitto_account_params)

    respond_to do |format|
      if @mosquitto_account.save
        format.html { redirect_to @mosquitto_account, notice: 'Mosquitto account was successfully created.' }
        format.json { render :show, status: :created, location: @mosquitto_account }
      else
        format.html { render :new }
        format.json { render json: @mosquitto_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mosquitto_accounts/1
  # PATCH/PUT /mosquitto_accounts/1.json
  def update
    respond_to do |format|
      if @mosquitto_account.update(mosquitto_account_params)
        format.html { redirect_to @mosquitto_account, notice: 'Mosquitto account was successfully updated.' }
        format.json { render :show, status: :ok, location: @mosquitto_account }
      else
        format.html { render :edit }
        format.json { render json: @mosquitto_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mosquitto_accounts/1
  # DELETE /mosquitto_accounts/1.json
  def destroy
    @mosquitto_account.destroy
    respond_to do |format|
      format.html { redirect_to mosquitto_accounts_url, notice: 'Mosquitto account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mosquitto_account
      @mosquitto_account = MosquittoAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mosquitto_account_params
      params.require(:mosquitto_account).permit(:username, :password, :superuser, :provision_request_id)
    end
end
