# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
words_with_descriptions = {
  "the": "A big yellow sun in the sky.",
  "be": "A smiling sunflower.",
  "to": "An arrow pointing up.",
  "of": "A piece of cheese.",
  "and": "Two smiling friends holding hands.",
  "a": "A cute little red apple.",
  "in": "A colorful house with a door.",
  "that": "A pointing finger.",
  "have": "A happy child with a toy.",
  "I": "A child pointing to themselves.",
  "it": "A friendly puppy wagging its tail.",
  "for": "A gift with a ribbon.",
  "not": "A crossed-out circle.",
  "on": "A happy bird on a branch.",
  "with": "Two friends hugging.",
  "he": "A happy boy with a cap.",
  "as": "A big heart filled with love.",
  "you": "A smiling child pointing at you.",
  "do": "A child playing with toys.",
  "at": "A cat sitting on a mat.",
  "this": "A hand holding a colorful ball.",
  "but": "Two friends holding different toys.",
  "his": "A boy holding a picture of his family.",
  "by": "A bicycle parked near a tree.",
  "from": "A plane flying in the sky.",
  "they": "A diverse group of children playing.",
  "we": "A group of friends holding hands.",
  "say": "A speech bubble with a smiley face.",
  "her": "A girl holding a bouquet of flowers.",
  "she": "A girl playing with a doll.",
  "or": "Two choices: an apple or an orange.",
  "an": "An adorable little kitten.",
  "will": "A genie granting a wish.",
  "my": "A child pointing to their chest.",
  "one": "A single red balloon.",
  "all": "A group of friends holding hands in a circle.",
  "would": "A thinking bubble with a question mark.",
  "there": "A finger pointing into the distance.",
  "their": "A family holding hands.",
  "what": "A child with a confused expression.",
  "so": "A child jumping with joy.",
  "up": "A child reaching for the stars.",
  "out": "A child going out through a door.",
  "if": "A key fitting into a locked door.",
  "about": "A group of friends talking and laughing.",
  "who": "A magnifying glass searching for someone.",
  "get": "A child receiving a present.",
  "which": "Two arrows pointing in different directions.",
  "go": "A child running with excitement.",
  "me": "A child holding a sign that says 'me'.",
}

household_items = {
  "chair": "A wooden chair with a tall backrest, four legs, and a soft cushion for comfortable sitting. It is the color of dark brown chocolate.",
  "table": "A rectangular table made of smooth, shiny wood with four legs. On top of the table, there is a red vase with flowers and a yellow bowl with fruits.",
  "bed": "A cozy bed with a fluffy mattress, a soft blanket, and fluffy pillows. The bed is covered in light blue sheets with stars and a teddy bear sits on it.",
  "plate": "A round plate made of white ceramic with a blue floral pattern around the edges. On the plate, there is a delicious slice of pizza topped with cheese and vegetables.",
  "cup": "A small cup made of clear glass with a red handle. The cup is filled with milk, and there are colorful sprinkles on top. It is sitting on a saucer.",
  "spoon": "A shiny silver spoon with a long handle and a curved, oval-shaped scoop. The spoon is used for eating soup, and it is resting on a yellow napkin.",
  "fork": "A silver fork with four pointy prongs. It is used for eating spaghetti. The fork is placed on a blue plate, next to a meatball covered in tomato sauce.",
  "knife": "A sharp knife with a silver blade and a black handle. The knife is used for cutting fruits and vegetables. It is placed on a cutting board next to sliced apples.",
  "book": "A colorful book with a hardcover. The book has pictures of animals and a big yellow sun on the cover. It is open to a page with a smiling lion.",
  "toy": "A soft, cuddly teddy bear with brown fur and a big smile. The bear is wearing a red bowtie and is sitting on a shelf surrounded by other toys.",
  "lamp": "A tall, slender lamp with a round shade. The lamp has a silver base and a white shade. When turned on, the lamp emits a warm, soft glow.",
  "clock": "A round clock with black numbers and hands. The clock has a white face and is hanging on the wall. The hands show that it is 3 o'clock.",
  "mirror": "A shiny mirror with a golden frame. When you look into the mirror, you can see your own reflection. The mirror is hanging on the wall.",
  "brush": "A hairbrush with a pink handle and soft bristles. The brush is used for combing hair. It is sitting on a vanity table next to a hair tie.",
  "bowl": "A round bowl made of ceramic with a blue and white pattern. The bowl is filled with colorful fruits like apples, oranges, and grapes.",
  "vacuum": "A red vacuum cleaner with a long handle and a hose. The vacuum is used to clean the floor. It has wheels and is plugged into a power outlet.",
  "cupboard": "A tall cupboard with shelves and doors. The cupboard is made of light brown wood. On the shelves, there are neatly stacked plates, cups, and bowls.",
  "sink": "A white sink with a silver faucet. The sink is filled with soapy water, and there are dirty dishes inside waiting to be washed.",
  "toilet": "A white toilet with a lid and a flush handle. The toilet is in a small room called the bathroom. It has a roll of toilet paper",
}
main_group = Group.create(name: "main")
food_category = Category.create(name: "Food & Drink")
house_items_category = Category.create(name: "Household Items")
animals_category = Category.create(name: "Animals")
common_category = Category.create(name: "Common")
places_category = Category.create(name: "Places")
core_items_category = Category.create(name: "Core")
foods = [
  "apple",
  "banana",
  "grapes",
  "strawberries",
  "blueberries",
  "watermelon",
  "carrot",
  "broccoli",
  "pizza",
  "hamburger",
  "hot dog",
  "french fries",
  "macaroni and cheese",
  "chicken nuggets",
  "peanut butter and jelly sandwich",
  "yogurt",
  "cheese",
  "milk",
  "ice cream",
  "cookies",
]
animals = [
  "dog",
  "cat",
  "bird",
  "fish",
  "elephant",
  "lion",
  "tiger",
  "bear",
  "monkey",
  "giraffe",
  "zebra",
  "horse",
  "cow",
  "sheep",
  "pig",
  "duck",
  "chicken",
  "frog",
  "turtle",
  "butterfly",
]
places = [
  "home",
  "park",
  "school",
  "zoo",
  "beach",
  "library",
  "playground",
  "store",
  "restaurant",
  "farm",
  "museum",
  "fire station",
  "police station",
  "hospital",
  "doctor's office",
  "grocery store",
  "movie theater",
  "petting zoo",
  "ice cream shop",
  "birthday party",
]
common_words = [
  "mom",
  "dad",
  "baby",
  "cat",
  "dog",
  "ball",
  "book",
  "car",
  "tree",
  "house",
  "shoes",
  "cup",
  "milk",
  "banana",
  "cookie",
  "bath",
  "bed",
  "hello",
  "bye",
  "yes",
]
existing_word_count = Word.count
puts "Existing #{existing_word_count} words"

if existing_word_count === 0
  household_items.each { |k, v| Word.create(name: k, picture_description: v, category_id: house_items_category.id) }
  foods.each { |i| Word.create(name: i, category_id: food_category.id) }
  animals.each { |i| Word.create(name: i, category_id: animals_category.id) }
  places.each { |i| Word.create(name: i, category_id: places_category.id) }
  common_words.each { |i| Word.create(name: i, category_id: common_category.id) }
  words_with_descriptions.each { |k, v| Word.create(name: k, picture_description: v, category_id: core_items_category.id) }

  puts "Seeded #{Word.count} words"
else
  puts "Skipping word creation"
end
user = User.new
user.email = "test@example.com"
user.password = "valid_password"
user.password_confirmation = "valid_password"
# user.encrypted_password = '#$taawktljasktlw4aaglj'
user.save!
