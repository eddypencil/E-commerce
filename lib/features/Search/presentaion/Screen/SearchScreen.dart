import 'dart:async';
import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/presentation/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/Search/presentaion/cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  static const int _debounceDurationMs = 500;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    
    if (query.length >= 4 && query.length % 4 == 0) {
      _search(query);
    }

    
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceDurationMs), () {
      if (query.isNotEmpty) {
        _search(query);
      }
    });
  }

  void _search(String query) {
    context.read<SearchCubit>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Search Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              focusNode: _focusNode,
              cursorColor: Colors.grey,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',

                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      _search(query);
                    }
                  },
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _search(query.trim());
                }
              },
            ),

            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    final List<Product> results = state.products;
                    if (results.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final product = results[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,SlideInPageRoute(page: ProductDetails(product: product)));
                          },
                          child: ListTile(
                            leading:
                                Image.network(product.thumbnail, width: 50),
                            title: Text(product.title),
                            subtitle: Text('${product.price} EGP'),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Search for products'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
