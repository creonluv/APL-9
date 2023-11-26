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

  def add_validation_rule(attribute, &block)
    @rules << Rule.new(attribute)
    instance_eval(&block)
  end

  def presence(message: nil)
    @rules.last.conditions << {
      type: :presence,
      message: message
    }
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
    @rules
  end

end
