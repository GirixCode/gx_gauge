import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;

  final Widget child;
  final double? height;
  final bool visible;
  final Color? color;
  const ItemCard({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.visible = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox();
    }
    return Card(
      elevation: 0.1,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: SizedBox(
        height: height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
