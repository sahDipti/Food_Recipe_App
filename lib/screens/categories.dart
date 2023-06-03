import 'package:flutter/material.dart';
import 'package:food_recipe/data/dummy_data.dart';
import 'package:food_recipe/models/meal.dart';
import 'package:food_recipe/widgets/category_grid_item.dart';
import 'package:food_recipe/screens/meals.dart';
import 'package:food_recipe/models/category.dart';

class CategoriesScreen extends StatefulWidget{
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
    });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
      );

      _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) { 
    void _selectCategory(BuildContext context, Category category){
    final filteredMeals = widget.availableMeals.where(
      (meal) => meal.categories.contains(category.id)).toList();
    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (ctx)=> MealsScreen(
          meals: filteredMeals,
          title: category.title,
        ),
      ),
    ); 
  }

    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for(final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: (){
                _selectCategory(context,category);
              }
            )
        ],
      ), 
      builder: (context,child)=> SlideTransition(
        position: Tween(
            begin: const Offset(0,0.3),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: _animationController, 
            curve: Curves.easeInOut,
            )),
        child: child,
      )
    );
}}