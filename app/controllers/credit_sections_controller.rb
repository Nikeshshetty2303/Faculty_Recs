class CreditSectionsController < ApplicationController
  before_action :set_credit_section, only: %i[ show edit update destroy ]

  # GET /credit_sections or /credit_sections.json
  def index
    @credit_sections = CreditSection.all
  end

  # GET /credit_sections/1 or /credit_sections/1.json
  def show
  end

  # GET /credit_sections/new
  def new
    @credit_section = CreditSection.new
  end

  # GET /credit_sections/1/edit
  def edit
  end

  # POST /credit_sections or /credit_sections.json
  def create
    @credit_section = CreditSection.new(credit_section_params)

    respond_to do |format|
      if @credit_section.save
        format.html { redirect_to credit_section_url(@credit_section), notice: "Credit section was successfully created." }
        format.json { render :show, status: :created, location: @credit_section }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @credit_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credit_sections/1 or /credit_sections/1.json
  def update
    respond_to do |format|
      if @credit_section.update(credit_section_params)
        format.html { redirect_to credit_section_url(@credit_section), notice: "Credit section was successfully updated." }
        format.json { render :show, status: :ok, location: @credit_section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @credit_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_sections/1 or /credit_sections/1.json
  def destroy
    @credit_section.destroy

    respond_to do |format|
      format.html { redirect_to credit_sections_url, notice: "Credit section was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_section
      @credit_section = CreditSection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credit_section_params
      params.require(:credit_section).permit(:title)
    end
end
