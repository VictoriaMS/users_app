FactoryBot.define do
  factory :user do
    name { 'Иван' }
    surname { 'Иванов' }
    patronymic { 'Иванович' }
    email { 'ivan@example.com' }
    age { 30 }
    nationality { 'Russian' }
    country { 'Russia' }
    gender { 'male' }
  end
end
