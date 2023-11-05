class UploadSectionsController < ApplicationController
  before_action :set_upload_section, only: %i[ show edit update destroy ]

  # GET /upload_sections or /upload_sections.json
  def index
    @upload_sections = UploadSection.all
  end

  # GET /upload_sections/1 or /upload_sections/1.json
  def show
  end

  # GET /upload_sections/new
  def new
    @upload_section = UploadSection.new
  end

  # GET /upload_sections/1/edit
  def edit
  end

  # POST /upload_sections or /upload_sections.json
  def create
    @upload_section = UploadSection.new(upload_section_params)

    respond_to do |format|
      if @upload_section.save
        format.html { redirect_to upload_section_url(@upload_section), notice: "Upload section was successfully created." }
        format.json { render :show, status: :created, location: @upload_section }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @upload_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upload_sections/1 or /upload_sections/1.json
  def update
    respond_to do |format|
      if @upload_section.update(upload_section_params)
        format.html { redirect_to upload_section_url(@upload_section), notice: "Upload section was successfully updated." }
        format.json { render :show, status: :ok, location: @upload_section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @upload_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upload_sections/1 or /upload_sections/1.json
  def destroy
    @upload_section.destroy

    respond_to do |format|
      format.html { redirect_to upload_sections_url, notice: "Upload section was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload_section
      @upload_section = UploadSection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def upload_section_params
      params.require(:upload_section).permit(:title)
    end
end
