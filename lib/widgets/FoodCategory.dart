import 'package:appetite_demo/models/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:appetite_demo/widgets/FoodCard.dart';
import 'package:appetite_demo/Data/CategoryData.dart';

class FoodCategory extends StatelessWidget {
  final List<Category> _categories = categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FoodCard(
            categoryName: _categories[index].categoryName,
            imagePath: _categories[index].imagePath,
          );
        },
      ),
    );
  }
}
