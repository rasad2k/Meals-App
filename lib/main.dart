import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/category_meals_screen.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';
import 'package:meals_app/screens/filters_screen.dart';

import 'models/meal.dart';
import 'screens/tabs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten-free': false,
    'lactose-free': false,
    'vegetarian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    _filters = filterData;
    _availableMeals = DUMMY_MEALS.where(
      (meal) {
        if (_filters['gluten-free'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose-free'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        return true;
      },
    ).toList();
  }

  void _toggleFavorite(String mealID) {
    final currentIndex = _favoriteMeals.indexWhere(
      (meal) => meal.id == mealID,
    );
    if (currentIndex >= 0) {
      setState(
        () {
          _favoriteMeals.removeAt(currentIndex);
        },
      );
    } else {
      setState(
        () {
          _favoriteMeals.add(
            DUMMY_MEALS.firstWhere((meal) => meal.id == mealID),
          );
        },
      );
    }
  }

  bool _isMealFavorite(String mealID) {
    return _favoriteMeals.any((meal) => meal.id == mealID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Meals App",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.green,
        canvasColor: Color.fromRGBO(250, 250, 230, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(10, 10, 10, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(10, 10, 10, 1),
              ),
              headline6: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favoriteMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(
              _toggleFavorite,
              _isMealFavorite,
            ),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}
