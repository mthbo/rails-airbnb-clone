
languages = [
  Language.create(name: "French"),
  Language.create(name: "english"),
  Language.create(name: "spanish"),
  Language.create(name: "italian"),
  Language.create(name: "german"),
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
  User.create(
    first_name: Faker::Name.name,
    last_name: Faker::Name.last_name,
    password:  Faker::Internet.password,
    phone_number: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    address: "#{Faker::Address.street_address}, #{Faker::Address.city}",
    bio: Faker::Lorem.sentence,
    birth_date: Faker::Date.between(60.years.ago, Date.today)
  )
end

10.times do
  Offer.create(
    title: Faker::Name.title,
    description: Faker::Lorem.sentence,
    advisor: User.find(rand(1..10)),
    languages: languages.sample(rand(1..4)),
    means: means.sample(rand(1..5))
  )
end

5.times do
  Deal.create(
    request: Faker::Lorem.sentence,
    deadline: Faker::Date.backward(14),
    price:  Faker::Commerce.price,
    proposition: Faker::Lorem.sentence,
    proposition_at: Faker::Date.backward(34),
    accepted_at: Faker::Date.backward(24),
    closed_at: Faker::Date.backward(14),
    advisor_review: Faker::Lorem.sentence,
    client_review: Faker::Lorem.sentence,
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample,
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10))
  )
end


5.times do
  Deal.create(
    request: Faker::Lorem.sentence,
    deadline: Faker::Date.forward(14),
    price:  Faker::Commerce.price,
    proposition: Faker::Lorem.sentence,
    proposition_at: Faker::Date.backward(24),
    accepted_at: Faker::Date.backward(14),
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10))
  )
end

5.times do
  Deal.create(
    request: Faker::Lorem.sentence,
    deadline: Faker::Date.forward(24),
    price:  Faker::Commerce.price,
    proposition: Faker::Lorem.sentence,
    proposition_at: Faker::Date.backward(14),
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10))
  )
end

5.times do
  Deal.create(
    request: Faker::Lorem.sentence,
    deadline: Faker::Date.forward(34),
    offer: Offer.find(rand(1..10)),
    client: User.find(rand(1..10))
  )
end



puts "It's OK"


