require_relative 'task'

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
      else
        puts"There is no such type of condition"
      end
    end
  end

  def validate_presence(attribute, value, message)
    puts "Validating presence for #{attribute}: #{value}"
    puts "Error!!!: #{message}" if value.nil? || value.to_s.empty?
  end

  def validate_length(attribute, value, options)
    puts "Validating length for #{attribute}: #{value}"
    if value.to_s.length < options[:minimum] || value.to_s.length > options[:maximum]
      puts "Error: Length should be between #{options[:minimum]} and #{options[:maximum]}"
    end
  end

  def validate_numericality(attribute, value, options)
    puts "Validating numericality for #{attribute}: #{value}"
    # if options[:greater_than_or_equal_to] && value.to_i < options[:greater_than_or_equal_to]
    if value.to_i < options[:minimum] || value.to_i >= options[:maximum]
      raise ArgumentError, "Error: Value should be between #{options[:minimum]} and #{options[:maximum]}. Real value was #{value}"
      # puts "Error: Value should be greater than or equal to #{options[:minimum]}"
    end
    # # if options[:less_than] && value.to_i >= options[:less_than]
    # if
    #   puts "Error: Value should be less than #{options[:maximum]}"
    # end
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
  numericality minimum: 18, maximum: 100
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

is_valid = validator.validate_data(data_to_validate)
puts "Is valid? -> #{is_valid}"
