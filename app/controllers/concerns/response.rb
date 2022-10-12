module Response
  def json_response(object = {}, status = :ok)
    render json: {
      status: 200,
      response: true,
      data: nil,
      message: nil,
      err_message: nil,
    }.merge(object), status: status
  end
end
