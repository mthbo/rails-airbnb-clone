Objective.destroy_all
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
  Language.create(name: "Chinese"),
  Language.create(name: "Danish"),
  Language.create(name: "Dutch"),
  Language.create(name: "Hindi"),
  Language.create(name: "Japanese"),
  Language.create(name: "Portuguese"),
  Language.create(name: "Russian"),
  Language.create(name: "Swahili"),
  Language.create(name: "Arabic")
]

means = [
  Mean.create(name: "Messaging"),
  Mean.create(name: "Call"),
  Mean.create(name: "Video call"),
  Mean.create(name: "Meeting"),
  Mean.create(name: "Documents"),
  Mean.create(name: "Sign language")
]

users = []
10.times do
  users << User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "secret",
    phone_number: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    city: Faker::Address.city,
    country: Faker::Address.country_code,
    bio: Faker::Lorem.paragraph(20),
    birth_date: Faker::Date.between(60.years.ago, Date.today)
  )
end

offers = []
5.times do
  offers << Offer.create(
    title: Faker::Name.title,
    description: Faker::Lorem.paragraph(20),
    advisor: users.sample,
    languages: languages.sample(rand(1..4)),
    means: means.sample(rand(1..5)),
    pricing: 1
  )
end

offers_free = []
5.times do
  offers_free << Offer.create(
    title: Faker::Name.title,
    description: Faker::Lorem.paragraph(20),
    advisor: users.sample,
    languages: languages.sample(rand(1..4)),
    means: means.sample(rand(1..5)),
    pricing: 0
  )
end

offer_new_priced = Offer.create(
  title: Faker::Name.title,
  description: Faker::Lorem.paragraph(20),
  advisor: users.sample,
  languages: languages.sample(rand(1..4)),
  means: means.sample(rand(1..5)),
  pricing: 1
)

deals1 = []
10.times do
  offer = offers.sample
  deals1 << Deal.create(
    status: 5,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(0.days.ago, 1.day.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(5.days.ago, 6.days.ago),
    accepted_at: Faker::Time.between(3.days.ago, 4.days.ago),
    closed_at: Faker::Time.between(1.day.ago, 2.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    languages: offer.languages,
    means: offer.means
  )
end

10.times do
  offer = offers.sample
  deals1 << Deal.create(
    status: 5,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(0.days.ago, 1.day.ago),
    proposition: Faker::Lorem.paragraph(10),
    amount:  Faker::Commerce.price,
    proposition_at: Faker::Time.between(5.days.ago, 6.days.ago),
    accepted_at: Faker::Time.between(3.days.ago, 4.days.ago),
    closed_at: Faker::Time.between(1.day.ago, 2.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals1.each do |deal|
  3.times do
    Objective.create(
      description: Faker::Lorem.sentence,
      rating: (0..5).to_a.sample,
      deal: deal
    )
  end
end

deals1_free = []
10.times do
  offer = offers_free.sample
  deals1_free << Deal.create(
    status: 5,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(0.days.ago, 1.day.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(5.days.ago, 6.days.ago),
    accepted_at: Faker::Time.between(3.days.ago, 4.days.ago),
    closed_at: Faker::Time.between(1.day.ago, 2.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    languages: offer.languages,
    means: offer.means
  )
end

3.times do
  offer = offer_new_priced
  deals1_free << Deal.create(
    status: 5,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(0.days.ago, 1.day.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(5.days.ago, 6.days.ago),
    accepted_at: Faker::Time.between(3.days.ago, 4.days.ago),
    closed_at: Faker::Time.between(1.day.ago, 2.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 1.day.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals1_free.each do |deal|
  3.times do
    Objective.create(
      description: Faker::Lorem.sentence,
      rating: (0..5).to_a.sample,
      deal: deal
    )
  end
end

deals2 = []
5.times do
  offer = offers.sample
  deals2 << Deal.create(
    status: 3,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(14),
    amount:  Faker::Commerce.price,
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(3.days.ago, 4.days.ago),
    accepted_at: Faker::Time.between(1.day.ago, 2.days.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals2.each do |deal|
  3.times do
    Objective.create(
      description: Faker::Lorem.sentence,
      deal: deal
    )
  end
end

deals3 = []
5.times do
  offer = offers.sample
  deals3 << Deal.create(
    status: 1,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(24),
    amount:  Faker::Commerce.price,
    proposition: Faker::Lorem.paragraph(10),
    proposition_at: Faker::Time.between(1.day.ago, 2.days.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals3.each do |deal|
  3.times do
    Objective.create(
      description: Faker::Lorem.sentence,
      deal: deal
    )
  end
end

deals4 = []
5.times do
  offer = offers.sample
  deals4 << Deal.create(
    status: 0,
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Date.forward(34),
    languages: offer.languages,
    means: offer.means
  )
end


# urls = [
#   'http://lorempixel.com/100/100/people/1/',
#   'http://lorempixel.com/100/100/people/2/',
#   'http://lorempixel.com/100/100/people/3/',
#   'http://lorempixel.com/100/100/people/4/',
#   'http://lorempixel.com/100/100/people/5/',
#   'http://lorempixel.com/100/100/people/6/',
#   'http://lorempixel.com/100/100/people/7/',
#   'http://lorempixel.com/100/100/people/8/',
#   'http://lorempixel.com/100/100/people/9/',
#   'http://lorempixel.com/100/100/people/10/'
# ]

# users.each_with_index do |user, index|
#   user.photo_url = urls[index]
# end



