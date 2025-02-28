class Skill < ApplicationRecord
    #Первый путь: Переименовать модель Skil в Skill. Я выбрала этот, потоиу что код станет более читаемым и мы сможем избежать путаницы. 
  #Второй путь: Оставить Skil, но использовать class_name: 'Skil' в ассоциациях.

  has_and_belongs_to_many :users
end
