require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_params) do
    {
      'name' => 'Иван',
      'surname' => 'Иванов',
      'patronymic' => 'Иванович',
      'email' => 'ivan@example.com',
      'age' => 30,
      'nationality' => 'Russian',
      'country' => 'Russia',
      'gender' => 'male',
      'interests' => ['спорт', 'чтение'],
      'skills' => 'ruby,rails'
    }
  end

  let!(:interest_sport) { create(:interest, name: 'спорт') }
  let!(:interest_reading) { create(:interest, name: 'чтение') }
  let!(:skill_ruby) { create(:skill, name: 'ruby') }
  let!(:skill_rails) { create(:skill, name: 'rails') }

  describe '#execute' do
    context 'with valid params' do
      it 'creates a user with interests and skills' do
        result = described_class.run(params: valid_params)
        expect(result).to be_valid
        user = result.result
        expect(user).to be_persisted
        expect(user.interests.map(&:name)).to match_array(['спорт', 'чтение'])
        expect(user.skills.map(&:name)).to match_array(['ruby', 'rails'])
      end
    end

    context 'with duplicate email' do
      before { create(:user, email: valid_params['email']) }

      it 'does not create a duplicate user' do
        result = described_class.run(params: valid_params)
        expect(result).not_to be_valid
        expect(result.errors[:params]).to include('Email already exists')
      end
    end

    context 'with invalid age' do
      it 'adds an error for age' do
        invalid_params = valid_params.merge('age' => 120)
        result = described_class.run(params: invalid_params)
        expect(result).not_to be_valid
        expect(result.errors[:params]).to include('Invalid age')
      end
    end

    context 'with invalid gender' do
      it 'adds an error for gender' do
        invalid_params = valid_params.merge('gender' => 'unknown')
        result = described_class.run(params: invalid_params)
        expect(result).not_to be_valid
        expect(result.errors[:params]).to include('Invalid gender')
      end
    end

    context 'with missing required params' do
      it 'adds an error for missing params' do
        invalid_params = valid_params.except('name')
        result = described_class.run(params: invalid_params)
        expect(result).not_to be_valid
        expect(result.errors[:params]).to include('name is missing')
      end
    end
  end
end
