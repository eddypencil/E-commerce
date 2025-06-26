import 'package:e_commerce/features/products/domain/entites.dart';

abstract class CartState{}

class CartLoading extends CartState{}

class CartLoaded extends CartState{
  final Map<Product,int> cart;

  CartLoaded({required this.cart});
}