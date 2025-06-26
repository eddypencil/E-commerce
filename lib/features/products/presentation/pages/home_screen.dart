import 'dart:developer';

import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/Search/presentaion/Screen/SearchScreen.dart';
import 'package:e_commerce/features/Search/presentaion/cubit/search_cubit.dart';
import 'package:e_commerce/features/map/presentation/cubit/locationCubit.dart';
import 'package:e_commerce/features/map/presentation/cubit/markerCubit.dart';
import 'package:e_commerce/features/map/presentation/screens/locationsScreen.dart';
import 'package:e_commerce/features/map/presentation/screens/screen_map.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/presentation/blocs/Product_cubit.dart';
import 'package:e_commerce/features/products/presentation/pages/product_details.dart';
import 'package:e_commerce/features/products/presentation/widgets/cart_icon.dart';
import 'package:e_commerce/features/products/presentation/widgets/catogrie_card.dart';
import 'package:e_commerce/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../blocs/product_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..getProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Skeletonizer(
                enabled: true,
                child: ProductsScrollView(
                  isLoading: true,
                  isGridLoading: true,
                ),
              );
            } else if (state is ProductsLoaded) {
              return ProductsScrollView(
                isGridLoading: false,
                isLoading: false,
                categoriesEntityList: state.categoryEntityList,
                categories:
                    state.categoryEntityList.map((c) => c.name).toList(),
                products: state.productsList,
              );
            } else if (state is CategoryItemsLoading) {
              return ProductsScrollView(
                  isLoading: false,
                  isGridLoading: true,
                  categoriesEntityList: state.categoryEntityList,
                  categories:
                      state.categoryEntityList.map((c) => c.name).toList(),
                  products: state.productsList);
            } else {
              return Center(
                child: Text(
                  "Something went wrong!",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductsScrollView extends StatefulWidget {
  final bool isLoading;
  final bool isGridLoading;
  final List<CategoryEntity>? categoriesEntityList;
  final List<String>? categories;
  final List<dynamic>? products;
  final int? selectedIndex;

  const ProductsScrollView({
    super.key,
    this.isLoading = false,
    this.isGridLoading = false,
    this.categoriesEntityList,
    this.categories,
    this.products,
    this.selectedIndex,
  });

  @override
  State<StatefulWidget> createState() => _ProductsScrollViewState();
}

class _ProductsScrollViewState extends State<ProductsScrollView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 16,
          elevation: 16,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) => SearchCubit(),
                    child: SearchScreen(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[800]),
                    SizedBox(width: 8.w),
                    Text(
                      "Search products...",
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Discover products",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideInPageRoute(
                        page: MultiBlocProvider(
                          providers: [
                            BlocProvider<MarkersCubit>(
                              create: (_) => MarkersCubit(),
                            ),
                           BlocProvider<LocationCubit>(
                              create: (_) => LocationCubit(),
                            ),
                          ],
                          child: const LocationsScreen(),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "Pick Address",
                        style: GoogleFonts.onest(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        widget.isLoading ? 5 : (widget.categories?.length ?? 0),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (!widget.isLoading &&
                                widget.categoriesEntityList != null &&
                                index < widget.categoriesEntityList!.length) {
                              setState(() {
                                selectedIndex = index;
                              });
                              context.read<ProductCubit>().getCategoryItems(
                                  widget.categoriesEntityList![index]);
                            } else {
                              log("Category list still loading or invalid index");
                            }
                          },
                          child: CategoriesCard(
                            isSelected: isSelected,
                            category: widget.isLoading
                                ? "Loading..."
                                : widget.categories![index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        SliverSkeletonizer(
          enabled: widget.isGridLoading,
          child: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (widget.isLoading || widget.isGridLoading) {
                    return SizedBox(width: 200.w, height: 200.h);
                  }
                  if (widget.products == null ||
                      index >= widget.products!.length) {
                    return SizedBox(); // or a loading placeholder
                  }
                  final product = widget.products![index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      SlideInPageRoute(page: ProductDetails(product: product)),
                    ),
                    child: ProductCard(
                      imageUrl: product.thumbnail,
                      title: product.title,
                      price: product.price,
                    ),
                  );
                },
                childCount: (widget.isLoading || widget.isGridLoading)
                    ? 10
                    : (widget.products?.length ?? 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
