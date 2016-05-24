class Student < Volt::Model
  own_by_user

  field :first_name, String
  field :last_name, String
  field :id_number
  field :shirt_size
  field :contact_number
  field :claimed
  field :course
  field :year
  field :date
  field :paid
  field :sized
  field :enrolled
  field :date

  validations do
    if sized
      validate :first_name, presence: {with: true,message: "Please specify first name"},
        format: {with: /^[a-zA-z.0-9 ]+$/, message: "Invalid symbols used in first name"}
      validate :last_name, presence: {with: true,message: "Please specify last name"},
        format: {with: /^[a-zA-z.0-9 ]+$/, message: "invalid symbols used in last name"}
      validate :shirt_size, presence: {with: true,message: "Please specify shirt size"}
      validate :contact_number, presence: {with: true,message: "Please specify contact number"},
      format: {with: /^((09|\+639)(\d{9}))|(\d{3}-\d{4})$/, message: "Invalid contact number format"}
      validate :course, presence: true
      validate :year, presence: true
    end
  end


  belongs_to :user

  validate :id_number, unique: {with: true, message: "ID number is already registered"},
    presence: {with: true,message: "Please specify ID number"},
    format: {with: /^\d{2}-\d{4}-\d{2}$/,message: "Invalid ID format"}


  def claim_shirt
    status = false
  end

  def normalize
    self.first_name.upcase
    self.last_name.upcase
  end
end
