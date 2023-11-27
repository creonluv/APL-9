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

class ValidationRuleDSL
  attr_accessor :rules

  def initialize
    @rules = []
    @current_rule
  end

  def add_validation_rule(attribute, &block)
    @current_rule = find_rule(attribute)
    if @current_rule.nil?
      @rules << Rule.new(attribute)
      @current_rule = @rules.last
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

  def numericality(rule: @current_rule,  **options)
    message = "Error: Value should be between #{options[:minimum]} and #{options[:maximum]}."
    put_conditions_in_rule(rule, :numericality, options, message)
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
