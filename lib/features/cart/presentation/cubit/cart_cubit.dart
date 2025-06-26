import 'dart:developer';

import 'package:e_commerce/features/cart/presentation/cubit/cart_states.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CartCubit extends HydratedCubit<CartState> {
  CartCubit() : super(CartLoaded(cart: {}));

 void addToCart(Product product) {
  if (state is CartLoaded) {
    final current = Map<Product, int>.from((state as CartLoaded).cart);
    current.update(product, (qty) => qty + 1, ifAbsent: () => 1);
    emit(CartLoaded(cart: current));
  }
}

void removeFromCart(Product product) {
  if (state is CartLoaded) {
    final current = Map<Product, int>.from((state as CartLoaded).cart);
    if (current.containsKey(product)) {
      if (current[product]! > 1) {
        current[product] = current[product]! - 1;
      } else {
        current.remove(product);
      }
      emit(CartLoaded(cart: current));
    }
  }
}
 @override
CartState? fromJson(Map<String, dynamic> json) {
  try {
    final items = json['cart'] as List<dynamic>;
    final Map<Product, int> products = {
      for (var item in items)
        Product.fromJson(item['product'] as Map<String, dynamic>): item['quantity'] as int,
    };
    return CartLoaded(cart: products);
  } catch (err, stack) {
    log('CartCubit.fromJson error: $err');
    log(stack.toString());
    return null;
  }
}

@override
Map<String, dynamic>? toJson(CartState state) {
  if (state is CartLoaded) {
    return {
      'cart': state.cart.entries
          .map((entry) => {
                'product': entry.key.toJson(),
                'quantity': entry.value,
              })
          .toList(),
    };
  }
  return null;
}
}