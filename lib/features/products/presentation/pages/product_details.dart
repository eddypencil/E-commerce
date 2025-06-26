import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/screens/cart_screen.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/presentation/pages/BottomNavBarScreen.dart';
import 'package:e_commerce/features/products/presentation/pages/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [

        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80.h,left:6 ,right: 6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductImages(product: widget.product),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RateAndReviews(product: widget.product),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TitleWidget(product: widget.product),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(widget.product.description,
                    style: GoogleFonts.onest(
                      color: Colors.grey[800],
                      fontSize: 16.sp,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DescriptionWidget(
                  product: widget.product,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReviewsWidget(
                  reviews: widget.product.reviews,
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        height: 100.h,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 28, left: 16, right: 16, top: 16),
          child: GestureDetector(
            onTap: () async {
              setState(() {
                _isloading = true;
              });
              context.read<CartCubit>().addToCart(widget.product);
              await Future.delayed(Duration(milliseconds: 500));
              setState(() {
                _isloading = false;
              });

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                isScrollControlled: true, // Optional, for full height
                builder: (context) {
                  return _AddToCartSheet(product: widget.product);
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isloading
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: Colors.grey[400],
                        ),
                      )
                    : Text(
                        "ADD TO CART",
                        style: GoogleFonts.onest(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddToCartSheet extends StatefulWidget {
  final Product product;
  const _AddToCartSheet({super.key, required this.product});

  @override
  __AddToCartSheetState createState() => __AddToCartSheetState();
}

class __AddToCartSheetState extends State<_AddToCartSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _headerOffset;
  late final Animation<Offset> _buttonsOffset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );


    _headerOffset = Tween<Offset>(
      begin: Offset(2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInQuad));

    // buttons come a little later
    _buttonsOffset = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // start it rolling
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 300.h,
        child: Column(
          children: [
            // Header row slides up first
            SlideTransition(
              position: _headerOffset,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.product.images[0]),
                    radius: 50.h,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.onest(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h,),
                        Text(
                          " ${widget.product.price} EGP",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.onest(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50.h),

            // Buttons row slides up a bit later
            SlideTransition(
              position: _buttonsOffset,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        SlideInPageRoute(page: BottomNavBarScreen()),
                      ),
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "CONTINUE BROWSING",
                            style: GoogleFonts.onest(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        SlideInPageRoute(page: CartScreen()),
                      ),
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.grey, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "GO TO CART",
                            style: GoogleFonts.onest(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.onest(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: GoogleFonts.onest(
                  color: Colors.grey[700],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        product.stock == 0
            ? Text(
          "Out of Stock",
          style: GoogleFonts.onest(
              fontSize: 18.sp,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold),
        )
            : SizedBox.shrink()
      ],
    );
  }
}

class RateAndReviews extends StatelessWidget {
  const RateAndReviews({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.solidStar,
          color: Colors.orangeAccent,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          product.rating.toString(),
          style: GoogleFonts.onest(
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
              fontSize: 24.sp),
        ),
        SizedBox(
          width: 23,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(24.r)),
          height: 35.h,
          width: 120.w,
          child: Center(
              child: Text(
            "${product.reviews.length} reviews",
            style: GoogleFonts.onest(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          )),
        ),
      ],
    );
  }
}

class ProductImages extends StatefulWidget {
  final Product product;

  const ProductImages({
    super.key,
    required this.product,
  });

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int _imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250.h,
          margin: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              widget.product.images[_imageIndex],
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 100.h,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageIndex = index;
                    });
                  },
                  child: Container(
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4), // drop shadow down 4px
                          blurRadius: 8, // soften
                          spreadRadius: -3, // tighten sides
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        widget.product.images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewsWidget extends StatefulWidget {
  final List<Review> reviews;

  const ReviewsWidget({super.key, required this.reviews});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final visibleReviews =
        _isExpanded ? widget.reviews : widget.reviews.take(1).toList();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.r)),
          child: ClipRect(
            clipBehavior: Clip.antiAlias,
            child: AnimatedSize(
              duration: Duration(milliseconds: 600),
              curve: Curves.bounceInOut,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REVIEWS",
                      style: GoogleFonts.onest(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...visibleReviews
                        .map((review) => ReviewTile(review: review))
                        
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          child: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: _isExpanded
                  ? Icon(Icons.keyboard_arrow_up)
                  : Icon(Icons.keyboard_arrow_down)),
        )
      ],
    );
  }
}

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r), color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  review.reviewerName,
                  style: GoogleFonts.onest(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6.sp,
                ),
                Icon(
                  FontAwesomeIcons.solidStar,
                  size: 16.sp,
                  color: Colors.orangeAccent,
                ),
                Text(review.rating.toString(),
                    style: GoogleFonts.onest(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    )),
                Spacer(),
                Text(
                  "${review.date.day}-${review.date.month}-${review.date.year}",
                  style: GoogleFonts.onest(
                      fontSize: 16.sp,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(review.comment, style: GoogleFonts.onest(fontSize: 18)),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            )
          ],
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatefulWidget {
  final Product product;

  const DescriptionWidget({super.key, required this.product});

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with title + expand icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DETAILS',
                        style: GoogleFonts.onest(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ],
                  ),

                  // This SizedBox gives a tiny bit of breathing room
                  if (!_isExpanded) SizedBox(height: 8.h),

                  Visibility(
                    visible: _isExpanded,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 20, thickness: 1),

                        // INFORMATION block
                        Text(
                          'INFORMATION',
                          style: GoogleFonts.onest(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Category: ${widget.product.category}"),
                        Text("Brand: ${widget.product.brand}"),
                        Text("Tags: ${widget.product.tags.join(', ')}"),
                        Text(
                            "Availability: ${widget.product.availabilityStatus}"),
                        Text("Warranty: ${widget.product.warrantyInformation}"),
                        Text("Return Policy: ${widget.product.returnPolicy}"),
                        Text(
                            "Shipping Info: ${widget.product.shippingInformation}"),
                        Text(
                            "Min. Order Qty: ${widget.product.minimumOrderQuantity}"),

                        const SizedBox(height: 12),

                        // DIMENSIONS block
                        Text(
                          'DIMENSIONS',
                          style: GoogleFonts.onest(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Height: ${widget.product.dimensions.height}"),
                        Text("Width: ${widget.product.dimensions.width}"),
                        Text("Depth: ${widget.product.dimensions.depth}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
