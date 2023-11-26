class ValidationRuleDSL
  attr_accessor :rules
  def initialize
    @rules = []
    puts @rules.size
  end

  def validate(attribute, &block)
    @rules ||= []
    rule = {
      attribute: attribute,
      conditions: []
    }
    @rules << rule
    instance_eval(&block)
    puts @rules.size
  end

  def presence(message: nil)
    @rules.last[:conditions] << {
      type: :presence,
      message: message
    }
  end

  def length(options)
    @rules.last[:conditions] << {
      type: :length,
      options: options
    }
  end

  def numericality(options)
    @rules.last[:conditions] << {
      type: :numericality,
      options: options
    }
  end

  def generate
    @rules.map { |rule| { rule[:attribute] => rule[:conditions] } }
  end

end

validation_rules = ValidationRuleDSL.new

puts 'Done 1'

validation_rules.validate(:username) do
  presence message: 'Username cannot be blank'
  length minimum: 3, maximum: 20
end

puts 'Done'

validation_rules.validate(:email) do
  presence message: 'Email cannot be blank'
end

validation_rules.validate(:age) do
  numericality greater_than_or_equal_to: 18, less_than: 100
end

rules = validation_rules.generate
puts "Validation Rules: "

rules.each do |rule|
  puts rule.to_s
end