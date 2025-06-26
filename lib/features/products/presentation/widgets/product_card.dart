import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double? price;

  const ProductCard({
    super.key,
    this.imageUrl,
    this.title,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // show network image or a grey placeholder with icon
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Image.network(
              imageUrl!,
              height: 130.h,
              width: 130.w,
              fit: BoxFit.cover,
            )
          else
            Container(
              height: 130.h,
              width: 130.w,
              color: Colors.grey[200],
              child: Icon(
                Icons.broken_image,
                size: 50.h,
                color: Colors.grey[400],
              ),
            ),

          const SizedBox(height: 8),

          // title
          Text(
            title ?? 'ERROR',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // price
          Text(
            price != null ? '\$${price!.toStringAsFixed(2)}' : 'ERROR',
            style: GoogleFonts.nunito(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
