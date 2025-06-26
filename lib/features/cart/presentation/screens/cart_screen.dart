import 'dart:developer';

import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_states.dart';
import 'package:e_commerce/features/payment/payment_manager.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'My Cart',
              style: GoogleFonts.onest(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: state is CartLoaded
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.cart.entries.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final cartItems = state.cart.entries.toList();
                            final entry = cartItems[index];
                            final product = entry.key;
                            final quantity = entry.value;

                            return _CartItemTile(
                              product: product,
                              name: product.title,
                              imageUrl: product.thumbnail,
                              price: product.price,
                              quantity: quantity,
                              onRemove: () {
                                context
                                    .read<CartCubit>()
                                    .removeFromCart(product);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _CheckoutSection(
                          total: state.cart.entries.fold<double>(
                            0,
                            (sum, entry) =>
                                sum + (entry.key.price * entry.value),
                          ),
                          onCheckout: () async {
                            final total = state.cart.entries.fold<double>(
                              0,
                              (sum, entry) =>
                                  sum + (entry.key.price * entry.value),
                            );

                            if (total <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Your cart is empty.")),
                              );
                              return;
                            }

                            final PaymentManager paymentManager =
                                PaymentManager();
                            final result = await paymentManager
                                .getPaymentKey(total.toInt());

                            result.fold(
                              (failure) {
                                log("Payment key error: $failure");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(failure)),
                                );
                              },
                              (paymentKey) async {
                                final url = Uri.parse(
                                  "https://accept.paymob.com/api/acceptance/iframes/933508?payment_token=$paymentKey",
                                );
                                if (!await launchUrl(url,
                                    mode: LaunchMode.inAppWebView)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Could not launch payment page.")),
                                  );
                                }
                              },
                            );
                          }),
                    ],
                  )
                : Skeletonizer(
                    child: Column(
                      children: [
                        Container(
                          width: 120.w,
                          height: 32.h,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (_, __) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 16.h,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 8.h),
                                        Container(
                                          width: 80.w,
                                          height: 14.h,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _CartItemTile extends StatefulWidget {
  final Product product;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.product,
  });

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(-1.5, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handelRemove() async {
    final quantity = context.read<CartCubit>().state is CartLoaded
        ? (context.read<CartCubit>().state as CartLoaded)
                .cart[widget.product] ??
            0
        : 0;

    if (quantity == 1) {
      await _animationController.forward();
    }

    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => Navigator.push(
            context,
            SlideInPageRoute(page: ProductDetails(product: widget.product)),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    widget.imageUrl,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.onest(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${widget.price.toStringAsFixed(2)} x ${widget.quantity}',
                        style: GoogleFonts.onest(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: _handelRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const _CheckoutSection({
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.onest(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.onest(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  backgroundColor: Colors.grey[300],
                ),
                onPressed: onCheckout,
                child: Text(
                  'Proceed to Checkout',
                  style: GoogleFonts.onest(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
