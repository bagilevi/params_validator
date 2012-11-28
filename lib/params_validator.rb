require 'bundler/setup'
Bundler.require(:default)

module ParamsValidator
  class InvalidValidatorException < Exception; end
  class InvalidParamsException < Exception
    attr_accessor :errors

    def message
      errors.map do |key, value|
        "#{Array(key).join(".")} #{value}"
      end.join(", ")
    end
  end
end

require 'params_validator/class_methods'
require 'params_validator/filter'
require 'params_validator/railtie'
require 'params_validator/validator'

