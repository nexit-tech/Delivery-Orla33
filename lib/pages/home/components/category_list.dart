import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.restaurant, "label": "Cortes"},
    {"icon": Icons.lunch_dining, "label": "Burgers"},
    {"icon": Icons.local_bar, "label": "Bebidas"},
    {"icon": Icons.icecream, "label": "Doces"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ]
                  ),
                  child: Icon(categories[index]['icon'], color: Colors.white, size: 28),
                ),
                const SizedBox(height: 8),
                Text(categories[index]['label'], style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}