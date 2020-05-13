class Profile < ActiveRecord::Base
  belongs_to :user

  validates :gender, inclusion: ["male", "female"]

  validate :both_names_not_null
  validate :no_boy_named_sue

  def both_names_not_null
  	if first_name == nil && last_name == nil
  		errors.add(:first_name, "cannot be nil if Last Name is nil!")
  	end
  end

  def no_boy_named_sue
  	if gender == "male" && first_name == "Sue"
  		errors.add(:first_name, "cannot be Sue if gender is male!")
  	end
  end

  def self.get_all_profiles(min_birth_year, max_birth_year)
  	Profile.where("birth_year BETWEEN :min_birth_year AND :max_birth_year", min_birth_year: min_birth_year, max_birth_year: max_birth_year).order(birth_year: :asc).to_a
  end

end
