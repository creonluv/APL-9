require_relative 'rules_creator'

class DataValidator

  def initialize(rules)
    @rules = rules
  end

  def validate_data(data)
    is_valid = true
    begin
      data.each do |attribute, value|
        rule = find_rule(attribute)
        validate_attribute(rule, value) if rule
      end
    rescue => e
      puts e.message
      is_valid = false
    end
    is_valid
  end

  private

  def find_rule(attribute)
    @rules.find { |rule| rule.attribute.to_s == attribute.to_s }
  end

  def validate_attribute(rule, value)
    puts "Validating #{rule.attribute} with value: #{value}"
    rule.conditions.each do |condition|
      type = condition[:type]
      options = condition[:options]
      message = condition[:message]
      validation_methods[type].call(rule.attribute, value, options, message)
    end
  end

  def validate_presence(attribute, value, options, message)
    puts "\tValidating presence for #{attribute}: #{value}"
    raise ArgumentError, "Error: #{message}" if value.nil? || value.to_s.empty?
  end

  def validate_length(attribute, value, options, message)
    puts "\tValidating length for #{attribute}: #{value}"
    if value.to_s.length < options[:minimum] || value.to_s.length > options[:maximum]
      raise ArgumentError, message
    end
  end

  def validate_in_range(attribute, value, options, message)
    puts "\tValidating in_range for #{attribute}: #{value}"
    if value.to_i < options[:minimum] || value.to_i >= options[:maximum]
      raise ArgumentError, message
    end
  end

  def validate_at_sign(attribute, value, options, message)
    puts "\tValidating '@' sign for #{attribute}: #{value}"
    unless value.to_s.include?('@')
      raise ArgumentError, message
    end
  end

  def validate_lowercase(attribute, value, options, message)
    puts "\tValidating full lowercase for #{attribute}: #{value}"
    unless value.to_s.downcase == value.to_s
      raise ArgumentError, message
    end
  end

  def validate_without_whitespaces(attribute, value, options, message)
    puts "\tValidating not contains whitespaces for #{attribute}: #{value}"
    if value.to_s.match(/\s/)
      raise ArgumentError, message
    end
  end

  def validate_without_spec_chars(attribute, value, options, message)
    puts "\tValidating not contains not allowed special characters for #{attribute}: #{value}"
    regex = /[!#\$%\^&\*\(\)\+\-=\[\]\{\};:'"\|,<>\/?\\]/
    if value.to_s.match(regex)
      raise ArgumentError, message
    end
  end

  def validation_methods
    @validation_methods ||= {
      presence: method(:validate_presence),
      length: method(:validate_length),
      in_range: method(:validate_in_range),
      at_sign: method(:validate_at_sign),
      lowercase: method(:validate_lowercase),
      without_whitespaces: method(:validate_without_whitespaces),
      without_spec_chars: method(:validate_without_spec_chars)
    }
  end

end

def object_to_hash(obj)
  data = {}

  obj.instance_variables.each do |var|
    key = var.to_s.delete('@').to_sym
    value = obj.instance_variable_get(var)
    data[key] = value
  end

  data
end