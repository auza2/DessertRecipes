# Dessert Recipes

The app makes an API call to the endpoint https://themealdb.com/api/json/v1/1/filter.php?c=Dessert to retrieve a list of desserts, which are then displayed in a list with thumbnail images. When a user taps on a dessert, another API call is made to https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID, where MEAL_ID is the ID of the selected dessert. Upon a successful response, the user is navigated to a detail view showing the dessert's image, ingredients list, instructions, and, if available, a YouTube video.

#### Example API Responses:

<ins>Fetch Desserts</ins> : /c=Dessert
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

<ins>Fetch Recipe for Specific Dessert</ins> : /lookup.php?i=52893
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
<br clear="left"/>

<img src="https://github.com/auza2/DessertRecipes/assets/17304405/96ff5fee-34a2-4d05-bae8-74beee24e1bd" width="200" align="left">

#### Search Functionality

- I implemented search functionality in the Dessert List view, allowing users to search through the list of desserts. By using a **@Query** property to fetch Dessert objects and a **@State** property to hold the search string, I enabled dynamic filtering of dessert names based on user input, while maintaining separate sections for favorites and non-favorites.

<br clear="left"/>

### Recipe Detail View
<img src="https://github.com/auza2/DessertRecipes/assets/17304405/e3ea563e-5cdc-4cad-98bf-39d1d8b5d610" width="200" align="left">

#### Asynchronous API Calls
- Made an **API call** using the ID from the tapped dessert with custom parameters defined using an enum for API calls.
- Implemented **view reuse** for CacheAsyncImage, avoiding redundant image downloads and optimizing performance.

#### Dessert to Recipe Relationship
- Established a relationship between each Dessert and its Recipe, enabling easy retrieval without searching.

#### Favorites Functionality
- Added a Favorite function in the top right corner, represented by an empty star. When tapped, the star fills, and the associated Dessert's isFavorite attribute is updated to true. This ensures that, upon navigating back to the Dessert List, the Dessert appears in the Favorited section.
<br clear="left"/>
<br clear="left"/>

<img src="https://github.com/auza2/DessertRecipes/assets/17304405/0ebf245f-a391-4476-803a-6880cc89085b" width="200" align="left">

#### Ingredient List with Tappable icon
As seen in the example API response for the lookup, we receive key-value pairs such as:
```
"strIngredient1": "Plain Flour",
...
"strMeasure1": "120g",
```
- I used the **Codable** protocol to decode these key-value pairs and a subscript to extract each ingredient and measure. These were then used to create Ingredient objects, forming an array of ingredients within the Recipe object and establishing a *relationship*. This setup allows each ingredient in the list to be tappable, providing visual feedback when tapped.

<br clear="left"/>


