import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function toggleFavorite;
  final Function isMealFavorite;

  MealDetailScreen(
    this.toggleFavorite,
    this.isMealFavorite,
  );

  Widget buildSectionTitle(BuildContext context, String text, double h) {
    return Container(
      height: h * 0.04,
      margin: EdgeInsets.symmetric(
        vertical: h * 0.01,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(Widget child, double availableH, double ratio) {
    return Container(
      margin: EdgeInsets.all(availableH * 0.005),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      height: availableH * ratio,
      width: 350,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealID = ModalRoute.of(context).settings.arguments;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealID);
    final availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final appBar = AppBar(
      title: Text('${selectedMeal.title}'),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Container(
            height: availableHeight * 0.20,
            width: double.infinity,
            child: Image.network(
              selectedMeal.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: availableHeight * 0.80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: <Widget>[
                buildSectionTitle(context, 'Ingredients', availableHeight),
                buildContainer(
                  ListView.builder(
                    itemBuilder: (ctx, index) => Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          selectedMeal.ingredients[index],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    itemCount: selectedMeal.ingredients.length,
                  ),
                  availableHeight,
                  0.27,
                ),
                buildSectionTitle(context, 'Steps', availableHeight),
                buildContainer(
                  ListView.builder(
                    itemBuilder: (ctx, index) => Container(
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              child: Text('#${(index + 1)}'),
                            ),
                            title: Text(
                              selectedMeal.steps[index],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    itemCount: selectedMeal.steps.length,
                  ),
                  availableHeight,
                  0.36,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => toggleFavorite(mealID),
        child: Icon(
          isMealFavorite(mealID) ? Icons.star : Icons.star_border,
        ),
      ),
    );
  }
}
