require_relative 'rules_validator'

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
      case condition[:type]
      when :presence
        validate_presence(rule.attribute, value, condition[:message])
      when :length
        validate_length(rule.attribute, value, condition[:options])
      when :numericality
        validate_numericality(rule.attribute, value, condition[:options])
      else
        puts "There is no such type of condition"
      end
    end
  end

  def validate_presence(attribute, value, message)
    puts "\tValidating presence for #{attribute}: #{value}"
    raise ArgumentError, "Error: #{message}" if value.nil? || value.to_s.empty?
  end

  def validate_length(attribute, value, options)
    puts "\tValidating length for #{attribute}: #{value}"
    if value.to_s.length < options[:minimum] || value.to_s.length > options[:maximum]
      raise ArgumentError, "Error: Length should be between #{options[:minimum]} and #{options[:maximum]}"
    end
  end

  def validate_numericality(attribute, value, options)
    puts "\tValidating numericality for #{attribute}: #{value}"
    if value.to_i < options[:minimum] || value.to_i >= options[:maximum]
      raise ArgumentError, "Error: Value should be between #{options[:minimum]} and #{options[:maximum]}. Real value was #{value}"
    end
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