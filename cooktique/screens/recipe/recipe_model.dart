class Recipe {
  final String title;
  final String category;
  final String image;
  final String description;
  final String author;
  final double rating;
  final String cookTime;
  final String servings;
  final String difficulty;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.title,
    required this.category,
    required this.image,
    required this.description,
    required this.author,
    required this.rating,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
  });
}

// 7 Data Dummy Global
final List<Recipe> dummyRecipes = [
  // --- 2 REGULAR RECIPES ---
  Recipe(
    title: "Butter Chicken Curry",
    category: "Regular",
    image: "https://images.unsplash.com/photo-1565557623262-b51c2513a641",
    description: "Rich and creamy Indian curry with tender chicken in a savory tomato-based sauce.",
    author: "Agus Khan",
    rating: 4.2,
    cookTime: "50 min",
    servings: "6",
    difficulty: "Easy",
    ingredients: [
      "800g skinless, boneless chicken thighs",
      "1 cup plain yogurt & 2 tbsp lemon juice",
      "2 tbsp garam masala & 1 tbsp turmeric",
      "1 can (14 oz) tomato puree",
      "1 cup heavy cream or whipping cream"
    ],
    instructions: [
      "Marinate chicken with yogurt, lemon juice, garlic, ginger, and spices.",
      "Heat oil and sear the chicken pieces until browned.",
      "Sauté chopped onions, add tomato puree.",
      "Pour in heavy cream and stir well.",
      "Return chicken back into the sauce and simmer."
    ],
  ),
  Recipe(
    title: "Creamy Garlic Pasta",
    category: "Regular",
    image: "https://images.unsplash.com/photo-1645112411341-6c4fd023714a",
    description: "Creamy garlic pasta perfect for a comforting meal.",
    author: "Chef Mario",
    rating: 4.5,
    cookTime: "20 min",
    servings: "2",
    difficulty: "Easy",
    ingredients: ["200g Pasta", "4 cloves Garlic", "1 cup Heavy Cream", "Parmesan Cheese"],
    instructions: ["Boil pasta.", "Sauté garlic.", "Add cream and cheese.", "Mix with pasta."],
  ),

  // --- 2 SIGNATURE RECIPES ---
  Recipe(
    title: "Chocolate Lava Cake",
    category: "Signature",
    image: "https://images.unsplash.com/photo-1563805042-7684c019e1cb",
    description: "Premium dessert with molten chocolate center.",
    author: "Cooktique Chef",
    rating: 4.9,
    cookTime: "30 min",
    servings: "2",
    difficulty: "Hard",
    ingredients: ["Dark Chocolate", "Butter", "Eggs", "Sugar", "Flour"],
    instructions: ["Melt chocolate.", "Whisk eggs and sugar.", "Bake for 12 mins at 200°C."],
  ),
  Recipe(
    title: "Signature Tiramisu",
    category: "Signature",
    image: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9",
    description: "Italian coffee-flavoured layered dessert.",
    author: "Cooktique Chef",
    rating: 4.8,
    cookTime: "40 min",
    servings: "4",
    difficulty: "Medium",
    ingredients: ["Mascarpone", "Espresso", "Ladyfingers", "Cocoa Powder"],
    instructions: ["Dip ladyfingers in espresso.", "Layer with mascarpone mix.", "Chill."],
  ),

  // --- 3 POPULAR SEARCHES ---
  Recipe(
    title: "Dendeng Balado",
    category: "Popular",
    image: "https://images.unsplash.com/photo-1544025162-d76694265947",
    description: "Crispy beef with spicy sambal balado.",
    author: "Ibu Minang",
    rating: 4.7,
    cookTime: "60 min",
    servings: "4",
    difficulty: "Medium",
    ingredients: ["Beef", "Red Chilies", "Shallots", "Garlic", "Lime"],
    instructions: ["Boil and slice beef.", "Fry until crispy.", "Sauté sambal and mix."],
  ),
  Recipe(
    title: "Ayam Betutu",
    category: "Popular",
    image: "https://images.unsplash.com/photo-1604908176997-431f65fdbf06",
    description: "Balinese spiced steamed and roasted chicken.",
    author: "Bli Made",
    rating: 4.6,
    cookTime: "90 min",
    servings: "5",
    difficulty: "Hard",
    ingredients: ["Whole Chicken", "Betutu Spice Paste", "Banana Leaves"],
    instructions: ["Rub chicken with spices.", "Wrap in banana leaves.", "Steam then roast."],
  ),
  Recipe(
    title: "Sate Pusut",
    category: "Popular",
    image: "https://images.unsplash.com/photo-1529042410759-befb1204b468",
    description: "Minced meat satay with grated coconut.",
    author: "Sasak Kitchen",
    rating: 4.5,
    cookTime: "45 min",
    servings: "3",
    difficulty: "Medium",
    ingredients: ["Minced Beef", "Grated Coconut", "Bamboo Skewers"],
    instructions: ["Mix meat and coconut.", "Wrap around skewers.", "Grill until brown."],
  ),
];