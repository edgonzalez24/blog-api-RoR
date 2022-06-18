FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published {
      randonNumber = rand(0..1)
      if randonNumber == 0
        false
      else
        true
      end
    }
    user
  end
end
