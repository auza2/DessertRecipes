# Dessert Recipes
This app makes an API call to the end point https://themealdb.com/api/json/v1/1/filter.php?c=Dessert to fetch a list of desserts and present them on a list with along with a thumbnail image. 
A user can then tap on the list item and another call to endpoint https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID where MEAL_ID is the id of the dessert.
Once the call has finished successfully, the user will be navigated to a list detail view which shows an image, ingredients list, instructions, and possibly a youtube video.

#### Example API Responses:

/c=Dessert
```
{
    "meals": [
        {
            "strMeal": "Apam balik",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
            "idMeal": "53049"
        },
        {
            "strMeal": "Apple & Blackberry Crumble",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            "idMeal": "52893"
        },
        {
            "strMeal": "Apple Frangipan Tart",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "idMeal": "52768"
        }
    ]
}
```

/lookup.php?i=52893
```
{
    "meals": [
        {
            "idMeal": "52893",
            "strMeal": "Apple & Blackberry Crumble",
            "strDrinkAlternate": null,
            "strCategory": "Dessert",
            "strArea": "British",
            "strInstructions": "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            "strTags": "Pudding",
            "strYoutube": "https://www.youtube.com/watch?v=4vhcOwVBDO4",
            "strIngredient1": "Plain Flour",
            "strIngredient2": "Caster Sugar",
            "strIngredient3": "Butter",
            "strIngredient4": "Braeburn Apples",
            "strIngredient5": "Butter",
            "strIngredient6": "Demerara Sugar",
            "strIngredient7": "Blackberrys",
            "strIngredient8": "Cinnamon",
            "strIngredient9": "Ice Cream",
            "strIngredient10": "",
            "strIngredient11": "",
            "strIngredient12": "",
            "strIngredient13": "",
            "strIngredient14": "",
            "strIngredient15": "",
            "strIngredient16": "",
            "strIngredient17": "",
            "strIngredient18": "",
            "strIngredient19": "",
            "strIngredient20": "",
            "strMeasure1": "120g",
            "strMeasure2": "60g",
            "strMeasure3": "60g",
            "strMeasure4": "300g",
            "strMeasure5": "30g",
            "strMeasure6": "30g",
            "strMeasure7": "120g",
            "strMeasure8": "¼ teaspoon",
            "strMeasure9": "to serve",
            "strMeasure10": "",
            "strMeasure11": "",
            "strMeasure12": "",
            "strMeasure13": "",
            "strMeasure14": "",
            "strMeasure15": "",
            "strMeasure16": "",
            "strMeasure17": "",
            "strMeasure18": "",
            "strMeasure19": "",
            "strMeasure20": "",
            "strSource": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "strImageSource": null,
            "strCreativeCommonsConfirmed": null,
            "dateModified": null
        }
    ]
}
```

## Shown Concepts
- Swift UI

Persistent Memory:
- Swift Data
- Codable Protocol
- Coding Keys
- Relationship

Design Pattern:
- MVVM
- Dependency Injection
- Data Binding


RESTful API:
- Network Layer
- Protocol Oriented Programming

## Features
### Dessert Recipe List
<img src="https://github.com/auza2/DessertRecipes/assets/17304405/5d82ff1d-9443-4f60-8722-00517a3f625b" width="200" align="left">

#### Asynchronous API Calls
- I used the **Codable** protocol to convert the API response into the Dessert data model and are then **persisted** in the data context using **Swift Data**
- Each list item displays the title and an image, which is loaded **asynchronously** using the CacheAsyncImage class with URLSession.
- **Images are cached in memory** using NSCache and stored in a dictionary, with the image URL as the key and the image as the value. This approach optimizes performance and reduces repeated network requests.

#### Favortes Section
- I implemented a Favorites functionality that splits the list into two sections which is implemented using two Queries that filter which Desserts are favorited and which are not and also sort the Desserts by name alphabetically.
- Each favorited item is marked with a yellow star, which is also displayed in the Detail View when a Dessert is favorited.

<br clear="left"/>


<img src="https://github.com/auza2/DessertRecipes/assets/17304405/96ff5fee-34a2-4d05-bae8-74beee24e1bd" width="200" align="left">

#### Search Functionality

I wanted to create a search functionality so that users would be able to search through all of the Desserts on the Dessert List and the two parts of the list have a filter on each one.
<br clear="left"/>

### Recipe Detail View
<img src="https://github.com/auza2/DessertRecipes/assets/17304405/e3ea563e-5cdc-4cad-98bf-39d1d8b5d610" width="200" align="left">

This detail view shows the details of the full Recipe. Once a user taps on a Dessert on the dessert list we are navigated to the Detail View where we call the meal_id API and use Codable again to create a data object, Recipe, from the response. I used a Relationship so that each Dessert has a Recipe and vice versa so that we would be able to persist each Recipe and we would not need to make another API call if we were to open the Recipe again.

Explain the Favorites Functionality on the top right.
<br clear="left"/>

### Ingredient List with Tappable icon
<img src="https://github.com/auza2/DessertRecipes/assets/17304405/0ebf245f-a391-4476-803a-6880cc89085b" width="200" align="left">

As you can see in the example response API for the look up we get keys and values such as:
```
"strIngredient1": "Plain Flour",
...
"strMeasure1": "120g",
```
This was tricky since there had to be a decision on whether on not to use the Codable Protocol to just create a Recipe with a bunch of empty Ingredients. I was set on creating a functionality where I could tap on each Ingredient List item and persist the list so that the user would be able to go through each Recipe and tap on the Ingredients they already have and to be able to do that we would need to create a data object so that Swift Data can persist each Ingredient as it is checked off.

<br clear="left"/>


