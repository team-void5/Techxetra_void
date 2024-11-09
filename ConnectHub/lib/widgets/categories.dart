import "package:connecthub/pages/services/services.dart";
import "package:connecthub/utils/my_colors.dart";
import "package:flutter/material.dart";
import "package:connecthub/utils/category_list.dart";

class Category extends StatefulWidget {
  const Category({
    super.key,
  });
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Services(srvCategory: categories[index]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  right: 8,
                ),
                child: Text(categories[index],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: secondaryText)),
              ));
        },
      ),
    );
  }
}
