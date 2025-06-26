import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesCard extends StatefulWidget {
  final String category;
  final bool isSelected;

  const CategoriesCard({super.key, required this.category, required this.isSelected});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isSelected? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48.sp),
      ),
      color: widget.isSelected ? Colors.grey[400] : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Center(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            widget.category,
            style: GoogleFonts.nunito(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color:widget.isSelected ? Colors.white : Colors.grey[850],
            ),
          ),
        ),
      ),
    );
  }
}
