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
  end

  def validate(attribute, &block)
    @rules << Rule.new(attribute)
    instance_eval(&block)
  end

  def presence(message: nil)
    @rules.last.conditions << {
      type: :presence,
      message: message
    }
    puts @rules.last.conditions.last[:type].class
  end

  def length(options)
    @rules.last.conditions << {
      type: :length,
      options: options
    }
  end

  def numericality(options)
    @rules.last.conditions << {
      type: :numericality,
      options: options
    }
  end

  def generate
    # @rules.map { |rule| { rule[:attribute] => rule[:conditions] } }
    @rules
  end

end

# validation_rules = ValidationRuleDSL.new
#
# validation_rules.validate(:username) do
#   presence message: 'Username cannot be blank'
#   length minimum: 3, maximum: 20
# end
#
# validation_rules.validate(:email) do
#   presence message: 'Email cannot be blank'
# end
#
# validation_rules.validate(:age) do
#   numericality greater_than_or_equal_to: 18, less_than: 100
# end
#
# rules = validation_rules.generate
#
# puts "Validation Rules: "
#
# rules.each do |rule|
#   puts rule.to_s
# end
