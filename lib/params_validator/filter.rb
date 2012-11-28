module ParamsValidator
  module Filter
    extend ActiveSupport::Inflector

    def self.validate_params(params, definition, ancestor_fields = [])
      errors = {}
      definition.each do |field, validation_definition|
        field_chain = ancestor_fields + [field]
        errors = validate_field(field, params, validation_definition[:_with], errors, field_chain)

        validation_definition.reject {|k,v| k == :_with }.each do |nested_field, nested_validation_definition|
          value = params && params.is_a?(Hash) && (params[field.to_s] || params[field.to_sym])
          validate_params(value, { nested_field => nested_validation_definition }, field_chain)
        end
      end
      if errors.count > 0
        exception = InvalidParamsException.new
        exception.errors = errors
        raise exception
      end
    end

    private

    def self.validate_field(field, params, validators, errors, field_chain = [])
      return errors unless validators
      validators.each do |validator_name|
        camelized_validator_name = self.camelize(validator_name)
        begin
          validator = constantize("ParamsValidator::Validator::#{camelized_validator_name}")
          value = params.is_a?(Hash) ? (params[field.to_s] || params[field.to_sym]) : nil
          unless validator.valid?(value)
            error_key = field_chain.size == 1 ? field : field_chain
            errors[error_key] = validator.error_message
          end
        rescue NameError
          raise InvalidValidatorException.new(validator_name)
        end
      end
      errors
    end
  end
end

