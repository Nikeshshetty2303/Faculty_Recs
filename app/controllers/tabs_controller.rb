class TabsController < ApplicationController
  before_action :set_tab, only: %i[ show edit update destroy ]

  # GET /tabs or /tabs.json
  def index
    @tabs = Tab.all
  end

  # GET /tabs/1 or /tabs/1.json
  def show
  end

  # GET /tabs/new
  def new
    @tab = Tab.new
  end

  # GET /tabs/1/edit
  def edit
  end

  # POST /tabs or /tabs.json
  def create
    @tab = Tab.new(tab_params)

    respond_to do |format|
      if @tab.save
        format.html { redirect_to tab_url(@tab), notice: "Tab was successfully created." }
        format.json { render :show, status: :created, location: @tab }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tabs/1 or /tabs/1.json
  def update
    respond_to do |format|
      if @tab.update(tab_params)
        format.html { redirect_to tab_url(@tab), notice: "Tab was successfully updated." }
        format.json { render :show, status: :ok, location: @tab }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tab.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tabs/1 or /tabs/1.json
  def destroy
    @tab.destroy

    respond_to do |format|
      format.html { redirect_to tabs_url, notice: "Tab was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tab
      @tab = Tab.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tab_params
      params.fetch(:tab, {})
    end
end
