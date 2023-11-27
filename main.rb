require_relative 'rules_creator'
require_relative 'data_validator'
require_relative 'entities'


validation_rules = ValidationRulesRepository.new

validation_rules.add_validation_rule(:username) do
  presence message: 'Username cannot be blank'
  without_whitespaces message: 'Username cannot contain whitespaces'
  length minimum: 3, maximum: 20
  without_spec_chars message: 'Username cannot contain not allowed special characters'
end

validation_rules.add_validation_rule(:email) do
  presence message: 'Email cannot be blank'
  at_sign message: "Email must contain '@' sign"
  lowercase message: 'Email must be in lowercase'
  without_spec_chars message: 'Email cannot contain not allowed special characters'
end

validation_rules.add_validation_rule(:age) do
  presence message: 'Age cannot be nil'
  in_range minimum: 18, maximum: 100
end

rules = validation_rules.generate

validator = DataValidator.new(rules)

data_to_validate = {
  username: "JohnDoe",
  email: "",
  age: nil
}

person_to_validate = Person.new("John.Doe9", "john.doe@example.com", 20)

data_to_validate = object_to_hash(person_to_validate)

puts data_to_validate.to_s

is_valid = validator.validate_data(data_to_validate)
puts "\nIs valid? -> #{is_valid}"