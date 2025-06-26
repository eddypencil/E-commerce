import 'package:flutter/material.dart';


class CartIcon extends StatelessWidget {
  final int numberOfItems;
  final VoidCallback onPressed;
  final double iconSize;

  const CartIcon({
    super.key,
    required this.numberOfItems,
    required this.onPressed,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          Icon(Icons.shopping_bag_outlined, size: iconSize),
          if (numberOfItems > 0) 
            Positioned(
              right: 0, 
              top: -3,
              child: Container(
                padding: EdgeInsets.all(iconSize * 0.12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  numberOfItems.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: iconSize * 0.45,
                    fontWeight: FontWeight.bold, // Make it stand out
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
