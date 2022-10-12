class ShortenersController < ApplicationController
  before_action :set_shortener, only: [:update, :destroy]

  # GET /shorteners
  def index
    visitor_count = VisitorCount.first
    visitor_count.update count: visitor_count.count + 1 if visitor_count.present?

    visitor_count = VisitorCount.create! count: 1 unless visitor_count.present?

    @shorteners = []

    Shortener.find_each do |short|
      @shorteners << short if short.try(:is_active) == true && short.try(:is_deleted) == false
    end

    json_response data: {
      count: Shortener.total_count,
      total_clicks: Shortener.total_clicks,
      visitor_count: visitor_count.count,
      links: ShortenersSerializer.new(@shorteners).serializable_hash[:data],
    }
  end

  # GET /shorteners/1
  def show
    # json_response data: @shortener

    # if params[:shortcode]
    @shortener = Shortener.find_by(shortcode: params[:id])
    if @shortener
      @shortener.update(last_accessed: Time.now, access_count: @shortener.access_count + 1)
      redirect_to @shortener.url
    else
      # render plain: "Invalid link", status: :unprocessable_entity
      # json_response({ err_message: "Invalid link" }, :unprocessable_entity)
      raise ExceptionHandler::InvalidAction, "invalid link"
    end
    # else
    #   render plain: "Welcome to shortster"
    # end
  end

  # POST /shorteners
  def create
    @shortener = Shortener.new(shortener_params)
    @shortener.shortcode = Shortener.generate_shortcode if shortener_params[:shortcode].blank?

    if @shortener.save
      data = ShortenersSerializer.new(@shortener).serializable_hash[:data][:attributes]
      json_response data: data, status: :created
    else
      json_response data: @shortener.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shorteners/1
  def update
    raise ExceptionHandler::InvalidAction, "invalid link id" unless @shortener.present?
    if @shortener.update(shortener_params)
      json_response({ data: ShortenersSerializer.new(@shortener).serializable_hash[:data][:attributes], message: "link updated" })
    else
      json_response data: @shortener.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shorteners/1
  def destroy
    @shortener.update(is_deleted: true)

    json_response({ data: {
      id: @shortener.id,
    }, message: "link deleted" })
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shortener
    @shortener = Shortener.find_by(id: params[:id], is_deleted: false, is_active: true, is_disabled: false)
  end

  # Only allow a list of trusted parameters through.
  def shortener_params
    params.require(:data).permit(:url, :title, :shortcode)
  end
end
