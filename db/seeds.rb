Deal.destroy_all
Offer.destroy_all
User.destroy_all
Mean.destroy_all
Language.destroy_all

languages = [
  Language.create(name: "French"),
  Language.create(name: "English"),
  Language.create(name: "Spanish"),
  Language.create(name: "Italian"),
  Language.create(name: "German"),
  Language.create(name: "Syrian"),
  Language.create(name: "Créole")
]

means = [
  Mean.create(name: "SMS"),
  Mean.create(name: "Facetime"),
  Mean.create(name: "Call"),
  Mean.create(name: "Minitel"),
  Mean.create(name: "Date")
]

10.times do

  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password:  Faker::Internet.password,
    phone_number: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    address: "#{Faker::Address.city}, #{Faker::Address.country_code}",
    bio: Faker::Lorem.paragraph(20),
    birth_date: Faker::Date.between(60.years.ago, Date.today)
  )
  user.save!

end

10.times do
  offer = Offer.new(
    title: Faker::Name.title,
    description: Faker::Lorem.paragraph(20),
    advisor: User.find(rand(1..10)),
    languages: languages.sample(rand(1..4)),
    means: means.sample(rand(1..5))
  )
  offer.save!
end

5.times do
  deal = Deal.new(
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10)),
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(0.days.ago, 1.day.ago),
    proposition: Faker::Lorem.paragraph(10),
    price:  Faker::Commerce.price,
    proposition_at: Faker::Time.between(5.days.ago, 6.days.ago),
    accepted_at: Faker::Time.between(3.days.ago, 4.days.ago),
    closed_at: Faker::Time.between(1.day.ago, 2.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample
  )
  deal.save!
end


5.times do
  deal = Deal.new(
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10)),
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(14),
    price:  Faker::Commerce.price,
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(3.days.ago, 4.days.ago),
    accepted_at: Faker::Time.between(1.day.ago, 2.days.ago)
  )
  deal.save!
end

5.times do
  deal = Deal.new(
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10)),
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(24),
    price:  Faker::Commerce.price,
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(1.day.ago, 2.days.ago)
  )
  deal.save!
end

5.times do
  deal = Deal.new(
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10)),
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(34)
  )
  deal.save!
end

urls = [
  'http://lorempixel.com/100/100/people/1/',
  'http://lorempixel.com/100/100/people/2/',
  'http://lorempixel.com/100/100/people/3/',
  'http://lorempixel.com/100/100/people/4/',
  'http://lorempixel.com/100/100/people/5/',
  'http://lorempixel.com/100/100/people/6/',
  'http://lorempixel.com/100/100/people/7/',
  'http://lorempixel.com/100/100/people/8/',
  'http://lorempixel.com/100/100/people/9/',
  'http://lorempixel.com/100/100/people/10/'
]


user1 = User.find(1)
user2 = User.find(2)
user3 = User.find(3)
user4 = User.find(4)
user5 = User.find(5)
user6 = User.find(6)
user7 = User.find(7)
user8 = User.find(8)
user9 = User.find(9)
user10 = User.find(10)

users = [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10]

users.each_with_index do |user, index|
  user.photo_url = urls[index]
end



