module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class InvalidProfileType < StandardError; end
  class InactiveWallet < StandardError; end
  class InvalidAPIKey < StandardError; end
  class DataType < StandardError; end
  class GatewayError < StandardError; end
  class InvalidToken < StandardError; end
  class InvalidAction < StandardError; end
  class InvalidAmount < StandardError; end
  class InvalidPhoneNumber < StandardError; end
  class RegularError < StandardError; end
  class ItemNotFound < StandardError; end

  # class Record < StandardError;

  class RestClientExceptionsOpenTimeout < StandardError; end
  class RestClientExceptionWithResponse < StandardError; end

  included do
    rescue_from StandardError do |e|
      case e.class
      when ActiveRecord::RecordNotFound
        four_zero_four(e)
      when ActiveRecord::RecordInvalid
        four_two_two(e.record.errors.full_messages)
      when ActionController::ParameterMissing
        four_zero_zero(e)
      when SocketError
      when Errno::ECONNREFUSED
        four_zero_zero(e)
      else
        five_zero_zero(e)
      end
    end
    rescue_from ExceptionHandler::InvalidProfileType, with: :four_zero_three

    rescue_from ExceptionHandler::InvalidAPIKey, with: :four_zero_three

    rescue_from ExceptionHandler::InvalidAction, with: :four_zero_three

    rescue_from ExceptionHandler::DataType, with: :four_zero_three

    rescue_from ExceptionHandler::GatewayError, with: :five_zero_two

    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ExceptionHandler::InvalidPhoneNumber, with: :four_two_two

    rescue_from ExceptionHandler::InvalidAmount, with: :four_zero_zero

    rescue_from ExceptionHandler::ItemNotFound, with: :four_zero_four

    rescue_from ExceptionHandler::InactiveWallet, with: :four_zero_two

    rescue_from ExceptionHandler::RestClientExceptionsOpenTimeout, with: :restclient_error

    rescue_from ExceptionHandler::RestClientExceptionWithResponse, with: :restclient_error

    rescue_from ExceptionHandler::RegularError do |e|
      json_response({ status: 422, response: false, data: nil, message: "Error", err_message: e.message || e }, :unprocessable_entity)
    end

    # rescue_from RestClient::Exceptions::OpenTimeout, with: :restclient_error

    # rescue_from RestClient::ExceptionWithResponse, with: :restclient_error

    # rescue_from RestClient::ResourceNotFound, with: :restclient_error
  end

  private

  def restclient_error(e)
    http_code = e.try(:http_code) || e.try(:[], :http_code) || e.try(:[], "http_code")
    err_message = e.try(:message) || e.try(:[], :message) || e.try(:[], "message") || e.try(:default_message) || e.try(:[], :default_message) || e.try(:[], "default_message")
    if e.try(:responsee) && e.response.present?
      response = JSON.parse(e.response)
      json_response({ status: http_code || 400, data: response, response: false, message: response.try(:[], "message"), err_message: err_message || "Oops, something went wrong" }, http_code || :bad_request)
    else
      json_response({ status: http_code || 400, data: nil, response: false, message: nil, err_message: err_message || "Oops, something went wrong" }, http_code || :bad_request)
    end
  end

  def four_zero_zero(e)
    json_response({ status: 400, data: nil, response: false, message: nil, err_message: e.message || e }, :bad_request)
  end

  def four_zero_two(e)
    json_response({ status: 402, data: nil, response: false, message: nil, err_message: e.message || e }, :payment_required)
  end

  def four_zero_three(e)
    json_response({ status: 403, data: nil, response: false, message: nil, err_message: e.message || e }, :forbidden)
  end

  def four_zero_four(e)
    json_response({ status: 404, data: nil, response: false, message: nil, err_message: e.message || e }, :not_found)
  end

  def four_zero_eight(e)
    json_response({ status: 408, data: nil, response: false, message: nil, err_message: e.message || e }, :request_timeout)
  end

  def four_two_two(e)
    json_response({ status: 422, data: nil, response: false, message: nil, err_message: e.message || e }, :unprocessable_entity)
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ status: 422, data: nil, message: nil, err_message: e.message || e }, :unprocessable_entity)
  end

  def five_zero_zero(e)
    json_response({ status: 500, data: nil, response: false, message: nil, err_message: e.message || e }, :internal_server_error)
  end

  def five_zero_two(e)
    json_response({ status: 502, data: nil, response: false, message: "gateway error", err_message: e.message || e }, :bad_gateway)
  end
end
