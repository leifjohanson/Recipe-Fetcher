# Recipe-Fetcher (v1.0)

##### Developer: Leif Johanson 
##### [Contact](https://www.linkedin.com/in/leifjohanson/)

## 1 Introduction

### 1.1 App Overview
Recipe-Fetcher is a native iOS application that get's recipe data from an [API](https://www.themealdb.com/api.php) and displays it to the user. A user can search by category and receive a detailed description of a selected recipe

## 2 Getting Started

### 2.1 Running the Application
In order to run this application, clone the code in this repository and run it using Xcode.

### 2.2 System Requirements
Since this is a native iOS application, macOS and Xcode (recommended to get the latest versions of each) are required. Since this application uses online API requests, an internet connection is required, and a strong one is highly recommended.

## 3 User Interface

### 3.1 General UI Overview
Recipe-Fetcher consists of three storyboard screens:
- A Welcome Screen (Figure 3.1.1)
- A Browse Recipe Screen (Figure 3.1.2)
- A Recipe Description Screen (Figure 3.1.3 and 3.1.4)





The Welcome Screen consists of a chef image, the app title, and a "Get Started" button. Once the user taps on the Get Started button, they are shown the Browse Recipe Screen, with recipe results from the "Beef" category. The user can then change the category, or select one of the results. Once they've select a result, they then are brought to the Recipe Description Screen, which presents a detailed description of the selected recipe.

## 4 Features

### 4.1 Feature Overview
Once the use reaches the Browse Recipe Screen, they are shown a screen with a selected category (Beef by default) and its results, and are able to either select a recipe or change categories by selecting on the various buttons below the "Categories" label.
There are 14 different categories, which are as follows:
- Beef
- Chicken
- Dessert
- Lamb
- Miscellaneous
- Pasta
- Pork
- Seafood
- Side
- Starter
- Vegan
- Vegatarian
- Breakfast
- Goat

This user is able to select any of these categories, and once they click the respective button, they an API request is made to get all the data under each category.

### 4.2 Handling Network Issues

Since this application is consistently using the Internet to get API requests, a strong network connection is essential for efficient use of this application. In the case that the user doesn't, results and especially images can take a while to load.

For images, a web source takes a while to load. So, when formulating all the results, the result views (ResultView.xib) are given a default image of Apple's system image "circles.hexagonpath.fill" (Figure 4.2.1). This will then get changed to the actual recipe image when the application has successfully retrieved the image from the url. Similar to this, the description can take a bit to load, so by default, the title says "Fetching your delicious recipes, please wait..." before the data has been successfully retried by the API (this is usually much quicker than the image).

These are implemented to show the user that the app itself is not broken, but their network is slow. If this application were to be production ready, a time-out timer would be implemented to show the user that their internet is too slow.

## 5 APIs

### 5.1 API Overview
This application uses lots of Apple's supplied API, but more intuitively uses [TheMealDB's](https://www.themealdb.com/api.php) API to fetch recipe data from the internet. It uses two endpoints, one to get a list of recipes by a given category (used on the Browse Recipes Screen), and the other to get a detailed recipe description given a recipe ID (used on the Recipe Description Screen).

#### 5.1.1 List of Recipes Endpoint
The user provides a category to the application by selecting one of the buttons under the Categories label on the Browse Recipes Screen. 

Once a category is selected, the API call begins. The category name is appended to the end of the API url, and then a [URLSession](https://developer.apple.com/documentation/foundation/urlsession) is created with the concatenated url.

The resulting data is decoded using Apple's [JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder) using the custom RecipeListData struct as a framework, and all the data is parsed and put into an array of RecipeListModel structs (with one RecipeListModel struct being somewhat of an equivalent to the JSON "meal" provided by the API), and returned so the ViewController can access and display the data.

#### 5.1.2 Recipe Description Endpoint
This API request works similarly to the aforementioned description above. When the user clicks on a result from the list of recipes on the Browse Recipes Screen, that result's ID is sent to RecipeManager.swift, added to a url, and a URLSession is created, with the data being decoded (using the RecipeData struct as a framework).

The data is then put into the custom RecipeModel struct and returned. The RecipeModel struct contains more data than the RecipeListModelStruct, and has these properties:
- idMeal (the id of the recipe)
- strMeal (the title of the recipe)
- strCategory (the recipe category, not currently used in v1.0)
- strArea (the region where the recipe originated, not currently used in v1.0)
- strInstructions (a String containing the instructions, with each instruction (usually) being delimited by the "\r\n" characters)
- strIngredients (a String array with each index being an ingredient, containing the API's meal.strIngredient1, meal.strIngredient2, ... , meal.strIngredient20, ignoring nil and empty values)
- strMeasures (a String array with each index being an ingredient measure, containing the API's meal.strMeasure1, meal.strMeasure2, ... , meal.strMeasure20, ignoring nil and empty values)

The RecipeModel also contains methods that better format the instructions and ingredients/measures.

## 6 Application Structure

### 6.1 Design Patters
This iOS application primarily uses two design patterns, which are as follows:

#### 6.1.1 Delegate Design Pattern
In order to make the code more intuitive and to simplify the file organization and structure, Fetch-Recipes uses the delegate design pattern. In Swift, this is often used with protocols. As this is the most commmon approach, this application uses protocols.

For example, the RecipeManagerDelegate has two methods, didUpdateRecipes() and didFailWithError().

didUpdateRecipes() tells the delegate to update the recipe description when a new API request is made with a new ID. Inside this method (in the RecipeDescriptionViewController.swift file), a DispatchQueue.main.async closure is used, and inside this closure is where all the information gets updated. didFailWithError() prints the error with the API, if one were to occur.

The RecipeListManagerDelegate works in a very similar way (see BrowseViewController.swift).

#### 6.1.2 Model-View-Controller (MVC) Design Pattern
In order to organize the code better and create different tasks for different components, this application uses a variation of the [MVC](https://developer.mozilla.org/en-US/docs/Glossary/MVC) design pattern. For example:
1. In the View, the user selects which category they would like search
2. In the Controller, the BrowseRecipeViewController.swift file has the instance of the RecipeListManagerDelegate call the didUpdateWeather() function, which is used in the Model folder.
3. The Model then uses the API to get this data and format it, and has the delegate pass it back to the BrowseViewController.swift file in the Controller folder.
4. The BrowseViewController then changes the Main.storyboard file in the View folder to display data to the user.

## 8 Conclusion
Although this documentation is fairly in-depth, it is hard to reference code blocks. Due to this, the Swift files (specifically in the Controller folder) contains comments on variables, methods, and more.

If any more questions, comments, or concerns were to arise, one should feel free to [contact the developer](https://www.linkedin.com/in/leifjohanson/).
