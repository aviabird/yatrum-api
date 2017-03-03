# Destroy Prev data if any
User.destroy_all
Trip.destroy_all
City.destroy_all
Place.destroy_all
Picture.destroy_all

admin_role = Role.find_or_create_by!(name: 'admin')
user_role = Role.find_or_create_by!(name: 'user')

puts "Roles Created!"

user = User.create!(name: 'Jack', email: 'jack@test.com', password: '1234567', password_confirmation: '1234567', role_id: user_role.id)
tags = %w(river rafting india america mountains treking cycling swiming camping religious nature)

images = [
  'https://unsplash.com/?photo=b1NFkUR-3Fg/download?force=true',
  'https://unsplash.com/?photo=3IEZsaXmzzs/download?force=true',
  'https://unsplash.com/?photo=9O1oQ9SzQZQ/download?force=true',
  'https://unsplash.com/?photo=zNN6ubHmruI/download?force=true',
  'https://unsplash.com/?photo=vL4ARRCFyg4/download?force=true',
  'https://unsplash.com/?photo=eJx43ng-fTU/download?force=true',
  'https://unsplash.com/?photo=oiLGd4Dd7eY/download?force=true',
  'https://unsplash.com/?photo=XN_CrZWxGDM/download?force=true',
  'https://unsplash.com/?photo=cmKPOUgdmWc/download?force=true',
  'https://unsplash.com/?photo=7bwQXzbF6KE/download?force=true'
]

10.times.each do |count|
  trip = user.trips.create!(name: "Pune trip #{count}", description: "Was mostly in summer #{count}")
  trip.tag_list.add(*tags.sample(rand(10)))
  trip.save!
  # city = trip.cities.create!(name: "Pune #{count}", country: 'India')
  place = trip.places.create!(name: "Agakhan Palace #{count}", description: "A very nice place #{count}", review: 'A good review')
  place.pictures.create!(url: images[count], description: 'just a pic')
end

user = User.create!(name: 'Chandra Shekhar', email: 'shekharait254@gmail.com', password: '1234567', password_confirmation: '1234567')
trip = user.trips.create!(name: 'My first to India', description: 'Company Trip', status: 'completed')
# city = trip.cities.create!(name: 'Pune', country: 'India')
place = trip.places.create!(name: 'Aga khan Palace', description: 'old fort', review: 'very nice place')
place.pictures.create!(url: "http://lorempixel.com/400/200", description: "Had so much fun here")

trip = user.trips.create!(name: 'My first to Dubai', description: 'Dubai Trip', status: 'completed')
# city = trip.cities.create!(name: 'Pune', country: 'India')
place = trip.places.create!(
  name: "Aga Khan Palace",
  description: %Q(
    The Aga Khan Palace was built by Sultan Muhammed Shah Aga Khan III in Pune, India. Built in 1892, 
    it is one of the biggest landmarks in Indian history. The palace was an act of charity by the Sultan who wanted
    to help the poor in the neighbouring areas of Pune, who were drastically hit by famine"),
  review: "Very nice palace"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Pune_Palace.jpg/1024px-Pune_Palace.jpg",
  description: "Outside Aga khan palace"
)

place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Gandhis_ashes.jpg/800px-Gandhis_ashes.jpg",
  description: "Gandhi's ashes at the palace"
)

place.pictures.create!(
  url: "https://i2.wp.com/www.chuzailiving.com/wp-content/uploads/2014/09/aga-khan-palace-pune-2.jpg",
  description: "outside view the palace"
)

place = trip.places.create!(
  name: "Shaniwar Wada",
  description: "Shaniwarwada (Śanivāravāḍā) is an 18th-century fortification in the city of Pune in Maharashtra, India. 
                Built in 1732,[1] it was the seat of the Peshwa rulers of the Maratha Empire until 1818, when the Peshwas 
                lost control to the East India Company after the Third Anglo-Maratha War. Following the rise of the Maratha Empire,
                the palace became the center of Indian politics in the 18th century",
  review: "Good place"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Shaniwarwada_gate.JPG/280px-Shaniwarwada_gate.JPG",
  description: "Gate of shaniwar wada"
)

place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Shaniwar_Wada_palace_fountain.JPG/220px-Shaniwar_Wada_palace_fountain.JPG",
  description: "Shaniwar wada palace fountain"
)

place = trip.places.create!(
  name: "Hyatt Regency",
  description: "This upscale hotel is a 4-minute walk from the nearest bus stop, 1.5 km from Aga Khan Palace and 8 km from the fortress of Shaniwar Wada.",
  review: "Nice rooms with nice food"
)
place.pictures.create!(
  url: "https://dubai.regency.hyatt.com/content/dam/PropertyWebsites/regency/dxbrd/Media/All/Hyatt-Regency-Dubai-P243-King-Room-with-City-and-Ocean-View.masthead-feature-panel-medium.jpg",
  description: "My room interior"
)
place.pictures.create!(
  url: "https://media-cdn.tripadvisor.com/media/photo-s/06/09/af/79/muslim-family-restaurant.jpg",
  description: "Having lunch with friends"
)

place = trip.places.create!(
  name: "Lohagad fort",
  description: "Lohagad (Marathi: लोहगड, iron fort) is one of the many hill forts of Maharashtra state in India. Situated close to the hill station Lonavala
                and 52 km (32 mi) northwest of Pune, Lohagad rises to an elevation of 1,033 m (3,389 ft) above sea level. The fort is connected
                to the neighboring Visapur fort by a small range. The fort was under the Maratha empire for the majority of time, with a short period of 5 years under the Mughal empire.",
  review: "nice fort"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Ganesh_Darwaja_Lohagad.jpg/800px-Ganesh_Darwaja_Lohagad.jpg",
  description: "At Lohgad fort main entrance"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Lohagad_wall.jpg/220px-Lohagad_wall.jpg",
  description: "Lohgad fort walls"
)

# city = trip.cities.create!(name: "Dubai", country: "UAE")
place = trip.places.create!(
  name: "Burj Khalifa",
  description: "The Burj Khalifa (Arabic: برج خليفة‎‎, Arabic for 'Khalifa Tower'; pronounced English /ˈbɜːrdʒ kəˈliːfə/),
                known as the Burj Dubai before its inauguration, is a megatall skyscraper in Dubai, United Arab Emirates.
                It is the tallest structure in the world, standing at 829.8 m ",
  review: "Nice view from top of the building", 
)
place.pictures.create!(
  url: "http://4.bp.blogspot.com/-9E_KTNVHeWU/VNGeKvoBZMI/AAAAAAAAMSc/6vjnkEaqxQw/s1600/Burj%2BKhalifa%2BPhoto%2Bat%2BNight%2B%2B03.jpg",
  description: "Burj Khalifa at night"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Burj_Khalifa_001.jpg/1024px-Burj_Khalifa_001.jpg",
  description: "Burj Khalifa NamePlate"
)

place = trip.places.create!(
  name: "Palm Islands", 
  description: "Palm Islands are three artificial islands, Palm Jumeirah, Deira Island and Palm Jebel Ali, on the coast of Dubai,
                United Arab Emirates. As of November 2014, only Palm Jumeirah has been completed. This island takes the form of a palm tree, 
                topped by a crescent. After completion, Palm Jebel Ali will take a similar shape; each island will be host to a large number of 
                residential, leisure and entertainment centers and will add a total of 520 kilometers of non-public beaches to the city of Dubai.",
  review: "Very nice place to visit"
)
place.pictures.create!(
  url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Palm_Jumeirah_early_evening_March_2015.jpg/1024px-Palm_Jumeirah_early_evening_March_2015.jpg",
  description: "Early evening view of palm islands"
)

place = trip.places.create!(
  name: "The Dubai Mall",
  description: "The Dubai Mall (Arabic: دبي مول‎‎) is a shopping mall in Dubai and the largest mall in the world by total area.
                Along with West Edmonton Mall in Canada, it is the nineteenth largest shopping mall in the world by gross leasable area.
                Located in Dubai, United Arab Emirates, it is part of the 20-billion-dollar Downtown complex, and includes 1,200 shops.
                In 2011 it was the most visited building on the planet, attracting over 54 million visitors. Access to the mall is provided 
                via Doha Street, rebuilt as a double-decker road in April 2009",
  review: "Expensive shopping and leisue complex"
)
place.pictures.create!(
  url: "https://i.ytimg.com/vi/1XnYjReHyT0/hqdefault.jpg",
  description: "Inside view of Dubai Mall"
)
place.pictures.create!(
  url: "http://c8.alamy.com/comp/D178H3/united-arab-emirates-uae-uae-middle-east-dubai-downtown-dubai-dubai-D178H3.jpg",
  description: "too much rush outside KFC"
)

place = trip.places.create!(
  name: "Ski Dubai",
  description: "Ski Dubai is an indoor ski resort with 22,500 square meters of indoor ski area.
                It is a part of the Mall of the Emirates, one of the largest shopping malls in the world, located in Dubai,
                United Arab Emirates. It was developed by Majid Al Futtaim Group, which also operates the Mall of the Emirates.",
  review: "Good Place for Indoor Activites at Dubai"
)
place.pictures.create!(
  url: "http://www.malloftheemirates.com/-/media/malloftheemirates/entertainment/skidubaii.jpg",
  description: "Skiing with the family and friends"
)
place.pictures.create!(
  url: "https://booking.skidxb.com/sites/default/files/styles/list-style/public/package_image/ski-school_0.jpg?itok=ZfZL10J5",
  description: "Having fun with friends"
)
