class Users::Create < ActiveInteraction::Base
  hash :params, default: {}, strip: false

  validates :params, presence: true
  validate :validate_required_keys, :validate_age, :validate_gender, :validate_email

  def execute
    user = build_user

    if user.save
      assign_associations(user)
      user
    else
      errors.merge!(user.errors)
      nil
    end
  end

  private

  def build_user
    User.new(params.slice('name', 'surname', 'patronymic', 'email', 'age', 'nationality', 'country', 'gender')).tap do |user|
      user.user_full_name = full_name
    end
  end

  def validate_required_keys
    %w[name patronymic email age nationality country gender].each do |key|
      errors.add(:params, "#{key} is missing") if params[key].blank?
    end
  end

  def validate_age
    if params['age'].to_i <= 0 || params['age'].to_i > 90
      errors.add(:params, 'Invalid age')
    end
  end

  def validate_gender
    unless %w[male female].include?(params['gender'].to_s.downcase)
      errors.add(:params, 'Invalid gender')
    end
  end

  def validate_email
    errors.add(:params, 'Email already exists') if User.exists?(email: params['email'])
  end

  def full_name
    [params['surname'], params['name'], params['patronymic']].compact.join(' ')
  end

  def assign_associations(user)
    assign_interests(user)
    assign_skills(user)
  end

  def assign_interests(user)
    interests = Interest.where(name: params['interests'])
    user.interests = interests if interests.any?
  end

  def assign_skills(user)
    skills = Skill.where(name: params['skills'].to_s.split(','))
    user.skills = skills if skills.any?
  end
end
