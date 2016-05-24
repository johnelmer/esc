class Database < Volt::Model
  field :id_num
  field :paid
  field :sized

  validate :id_num, unique: {with: true, message: "ID number is already registered"},
    presence: {with: true,message: "Please specify ID number"},
    format: {with: /^\d{2}-\d{4}-\d{2}$/,message: "Invalid ID format"}
end
