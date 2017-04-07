Objective.destroy_all
Message.destroy_all
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
  Language.create(name: "Arabic"),
  Language.create(name: "Swedish"),
  Language.create(name: "Greek"),
  Language.create(name: "Malaysian"),
  Language.create(name: "Indonesian"),
  Language.create(name: "Hungarian"),
  Language.create(name: "Norwegian"),
  Language.create(name: "Polish"),
  Language.create(name: "Brazilian Portuguese"),
  Language.create(name: "Finnish"),
  Language.create(name: "Turkish"),
  Language.create(name: "Icelandic"),
  Language.create(name: "Czech"),
  Language.create(name: "Thai"),
  Language.create(name: "Korean"),
  Language.create(name: "Persian"),
  Language.create(name: "Hebrew")
]

languages_short_list = [
  Language.find_by_name("English"),
  Language.find_by_name("Spanish"),
  Language.find_by_name("German"),
  Language.find_by_name("Italian"),
  Language.find_by_name("Arabic"),
  Language.find_by_name("Portuguese")
]

means = [
  Mean.create(name: "Messaging"),
  Mean.create(name: "Phone call"),
  Mean.create(name: "Video call"),
  Mean.create(name: "Meeting"),
  Mean.create(name: "Documents"),
  Mean.create(name: "Sign language")
]

means_short_list = [
  Mean.find_by_name("Phone call"),
  Mean.find_by_name("Video call"),
  Mean.find_by_name("Meeting"),
  Mean.find_by_name("Documents")
]

first_names = ['Ali', 'Alvaro', 'Ethan', 'Thomas', 'Gabriel', 'Sophie', 'Leïla', 'Louise', 'Emma', 'Jade']
last_names = ['Robinson', 'Hernandez', 'Martin', 'Boudreaux', 'Montague', 'Darcy', 'Bakri', 'Bellami', 'Jean', 'Wang']
cities = ['Paris', 'Nantes', 'Grenoble', 'Lyon', 'Paris', 'Toulouse', 'Bordeaux', 'Biarritz', 'Marseille', 'Brest']

users = []
i = 0
10.times do
  users << User.create(
    first_name: first_names[i],
    last_name: last_names[i],
    password: "password",
    phone_number: "+336#{Faker::PhoneNumber.subscriber_number(8)}",
    email: "#{first_names[i].downcase}.#{last_names[i].downcase}@papoters-test.com",
    city: cities[i],
    country_code: "FR",
    bio: Faker::Lorem.paragraph(20),
    birth_date: Faker::Time.between(60.years.ago, 18.years.ago)
  )
  i += 1
end

urls = [
  'https://randomuser.me/api/portraits/lego/4.jpg',
  'https://randomuser.me/api/portraits/lego/5.jpg',
  'https://randomuser.me/api/portraits/lego/3.jpg',
  'https://randomuser.me/api/portraits/lego/7.jpg',
  'https://randomuser.me/api/portraits/lego/1.jpg',
  'https://randomuser.me/api/portraits/lego/9.jpg',
  'http://cache.lego.com/r/catalogs/-/media/catalogs/characters/minifigures/series%2012/71007_portrait_ladygenie.png?l.r2=-406011569',
  'https://mi-od-live-s.legocdn.com/r/www/r/catalogs/-/media/catalogs/characters/minifigures/series%204/8804_portrait_surfer.png?l.r2=1328164149',
  'https://s-media-cache-ak0.pinimg.com/236x/e5/de/98/e5de98440203c3dcda49636b84d1d5a8.jpg',
  "https://mi-od-live-s.legocdn.com/r/www/r/careers/-/media/careers/images/module%20images/forgotpassword.jpg?l.r2=-164851152"
]

users.each_with_index do |user, index|
  user.photo_url = urls[index]
end

offer_titles = [
  "Découverte inédite des petits vignobles du bordelais",
  "Développer votre site premier site web: par où démarrer?",
  "S'installer comme développeur web freelance",
  "Surftrip sur la côte est australienne",
  "Connaître les outils pour développer facilement un site web",
  "Formater votre ordinateur et donner lui une seconde vie",
  "Devenir freelance: conseils et erreurs à éviter",
  "Bons plans pour surfer en Australie : vans, locations, secret spots ...",
  "Réusir son installation comme freelance à Paris",
  "Organiser un voyage hors du commun en Australie",
  "Session de nettoyage de votre ordinateur, mac ou PC",
  "Bonnes adresses de fermes artisanales et de vignobles en Aquitaine",
  "Conseils de parcours cyclables pour visiter la région bordelaise",
  "Conseils et outils utiles pour garder votre mac performant",
  "Se lancer dans le développement d'un site web"
]

i = 0

offers = []
7.times do
  offers << Offer.create(
    title: offer_titles[i],
    description: Faker::Lorem.paragraph(20),
    advisor: users.sample,
    languages: [Language.find_by_name("French")] + languages_short_list.sample(rand(0..3)),
    means: [Mean.find_by_name("Messaging")] + means_short_list.sample(rand(0..4)),
    pricing: "priced"
  )
  i += 1
end

offers_free = []
7.times do
  offers_free << Offer.create(
    title: offer_titles[i],
    description: Faker::Lorem.paragraph(20),
    advisor: users.sample,
    languages: [Language.find_by_name("French")] + languages_short_list.sample(rand(0..3)),
    means: [Mean.find_by_name("Messaging")] + means_short_list.sample(rand(0..4)),
    pricing: "free"
  )
  i += 1
end

offer_new_priced = Offer.create(
  title: offer_titles[i],
  description: Faker::Lorem.paragraph(20),
  advisor: users.sample,
  languages: [Language.find_by_name("French")] + languages_short_list.sample(rand(0..3)),
  means: [Mean.find_by_name("Messaging")] + means_short_list.sample(rand(0..3)) + [Mean.find_by_name("Sign language")],
  pricing: "priced"
)

deals1 = []
10.times do
  offer = offers.sample
  deals1 << Deal.new(
    status: "closed",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(15.days.ago, 40.days.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(41.days.ago, 45.day.ago),
    proposition_at: Faker::Time.between(51.days.ago, 60.days.ago),
    open_at: Faker::Time.between(46.days.ago, 50.days.ago),
    closed_at: Faker::Time.between(15.days.ago, 40.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample,
    languages: offer.languages,
    means: offer.means
  )
end

10.times do
  offer = offers.sample
  deals1 << Deal.new(
    status: "closed",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(15.days.ago, 40.days.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(41.days.ago, 45.day.ago),
    proposition_at: Faker::Time.between(51.days.ago, 60.days.ago),
    open_at: Faker::Time.between(46.days.ago, 50.days.ago),
    closed_at: Faker::Time.between(15.days.ago, 40.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample,
    languages: offer.languages,
    means: offer.means,
    amount: rand(10..50)
  )
end

deals1.each do |deal|
  3.times do
    deal.objectives.new(description: Faker::Lorem.sentence, rating: (0..5).to_a.sample)
  end
  deal.save
end

deals1_free = []
10.times do
  offer = offers_free.sample
  deals1_free << Deal.new(
    status: "closed",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(15.days.ago, 40.days.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(41.days.ago, 45.day.ago),
    proposition_at: Faker::Time.between(51.days.ago, 60.days.ago),
    open_at: Faker::Time.between(46.days.ago, 50.days.ago),
    closed_at: Faker::Time.between(15.days.ago, 40.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample,
    languages: offer.languages,
    means: offer.means
  )
end

3.times do
  offer = offer_new_priced
  deals1_free << Deal.new(
    status: "closed",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(15.days.ago, 40.days.ago),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(41.days.ago, 45.day.ago),
    proposition_at: Faker::Time.between(51.days.ago, 60.days.ago),
    open_at: Faker::Time.between(46.days.ago, 50.days.ago),
    closed_at: Faker::Time.between(15.days.ago, 40.days.ago),
    client_review: Faker::Lorem.paragraph(10),
    advisor_review: Faker::Lorem.paragraph(10),
    client_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    advisor_review_at: Faker::Time.between(0.days.ago, 14.days.ago),
    client_rating: (0..5).to_a.sample,
    advisor_rating: (0..5).to_a.sample,
    languages: offer.languages,
    means: offer.means
  )
end

deals1_free.each do |deal|
  3.times do
    deal.objectives.new(description: Faker::Lorem.sentence, rating: (0..5).to_a.sample)
  end
  deal.save
end

deals2 = []
5.times do
  offer = offers.sample
  deals2 << Deal.new(
    status: "open",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(1.days.from_now, 60.days.from_now),
    amount:  rand(10..50),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(0.days.ago, 5.days.ago),
    proposition_at: Faker::Time.between(11.days.ago, 15.days.ago),
    open_at: Faker::Time.between(6.days.ago, 10.days.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals2.each do |deal|
  3.times do
    deal.objectives.new(description: Faker::Lorem.sentence)
  end
  deal.save
end

deals3 = []
5.times do
  offer = offers.sample
  deals3 << Deal.new(
    status: "proposition",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(31.days.from_now, 60.days.from_now),
    amount:  rand(10..50),
    proposition: Faker::Lorem.paragraph(10),
    proposition_deadline: Faker::Time.between(10.days.from_now, 30.days.from_now),
    proposition_at: Faker::Time.between(1.day.ago, 2.days.ago),
    languages: offer.languages,
    means: offer.means
  )
end

deals3.each do |deal|
  3.times do
    deal.objectives.new(description: Faker::Lorem.sentence)
  end
  deal.save
end

deals4 = []
5.times do
  offer = offers.sample
  deals4 << Deal.create(
    status: "request",
    offer: offer,
    client: users.sample,
    request: Faker::Lorem.paragraph(10),
    deadline: Faker::Time.between(31.days.from_now, 60.days.from_now),
    languages: offer.languages,
    means: offer.means
  )
end



