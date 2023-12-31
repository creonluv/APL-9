class Rule
  attr_accessor :attribute, :conditions

  def initialize(attribute)
    @attribute = attribute
    @conditions = []
  end

  def to_s
    "\nRule for '#{attribute}' attribute: \nConditions => #{conditions}\n"
  end
end

class ValidationRulesRepository
  attr_accessor :rules

  def initialize
    @rules = []
    @current_rule
  end

  def add_validation_rule(attribute, &block)
    @current_rule = find_rule(attribute)
    if @current_rule.nil?
      rule = Rule.new(attribute)
      @rules << rule
      @current_rule = rule
    end
    instance_eval(&block)
  end

  def presence(message: nil)
    put_conditions_in_rule(@current_rule, :presence, nil, message)
  end

  def length(rule: @current_rule,  **options)
    message = "Error: Length should be between #{options[:minimum]} and #{options[:maximum]}"
    put_conditions_in_rule(rule, :length, options, message)
  end

  def in_range(rule: @current_rule, **options)
    message = "Error: Value should be between #{options[:minimum]} and #{options[:maximum]}."
    put_conditions_in_rule(rule, :in_range, options, message)
  end

  def at_sign(message: nil)
    put_conditions_in_rule(@current_rule, :at_sign, nil, message)
  end

  def lowercase(message: nil)
    put_conditions_in_rule(@current_rule, :lowercase, nil, message)
  end

  def without_whitespaces(message: nil)
    put_conditions_in_rule(@current_rule, :without_whitespaces, nil, message)
  end

  def without_spec_chars(message: nil)
    put_conditions_in_rule(@current_rule, :without_spec_chars, nil, message)
  end

  def put_conditions_in_rule(rule, type, options, message)
    rule.conditions << {
      type: type,
      options: options,
      message: message
    }
  end

  def find_rule(attribute)
    @rules.find { |rule| rule.attribute.to_s == attribute.to_s }
  end

  def generate
    @rules
  end

end
