require_relative 'task'

class DataValidator

  def initialize(rules)
    @rules = rules
  end

  def validate_data(data)
    data.each do |attribute, value|
      rule = find_rule(attribute)
      validate_attribute(rule, value) if rule
    end
  end

  private

  def find_rule(attribute)
    @rules.find { |rule| rule.attribute == attribute }
  end

  def validate_attribute(rule, value)
    puts "Validating #{rule.attribute} with value: #{value}"
    rule.conditions.each do |condition|
      case condition[:type]
      when :presence
        validate_presence(rule.attribute, value, condition[:message])
      when :length
        validate_length(rule.attribute, value, condition[:options])
      when :numericality
        validate_numericality(rule.attribute, value, condition[:options])
      end
    end
  end

  def validate_presence(attribute, value, message)
    puts "Validating presence for #{attribute}: #{value}"
    puts "Error: #{message}" if value.nil? || value.to_s.empty?
  end

  def validate_length(attribute, value, options)
    puts "Validating length for #{attribute}: #{value}"
    if value.to_s.length < options[:minimum] || value.to_s.length > options[:maximum]
      puts "Error: Length should be between #{options[:minimum]} and #{options[:maximum]}"
    end
  end

  def validate_numericality(attribute, value, options)
    puts "Validating numericality for #{attribute}: #{value}"
    if options[:greater_than_or_equal_to] && value.to_i < options[:greater_than_or_equal_to]
      puts "Error: Value should be greater than or equal to #{options[:greater_than_or_equal_to]}"
    end
    if options[:less_than] && value.to_i >= options[:less_than]
      puts "Error: Value should be less than #{options[:less_than]}"
    end
  end
end

# Використання
validation_rules = ValidationRuleDSL.new

validation_rules.validate(:username) do
  presence message: 'Username cannot be blank'
  length minimum: 3, maximum: 20
end

validation_rules.validate(:email) do
  presence message: 'Email cannot be blank'
end

validation_rules.validate(:age) do
  numericality greater_than_or_equal_to: 18, less_than: 100
end

rules = validation_rules.generate
#
validator = DataValidator.new(rules)
data_to_validate = {
  username: "JohnDoe",
  email: "john.doe@example.com",
  # email: "",
  age: 25
}

validator.validate_data(data_to_validate)
