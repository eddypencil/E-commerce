
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/network/end_points.dart';

class PaymentManager {
  final Dio dio = Dio();

  Future<Either<String, String>> getPaymentKey(int amount) async {
    try {
      final token = await _authenticate();
      final orderID = await _createOrder(token,amount);
      final paymentKey = await _generatePaymentKey(token, orderID,amount);
      return Right(paymentKey);
    } catch (e) {
      return Left("Payment process failed: $e");
    }
  }

  Future<String> _authenticate() async {
    try {
      final response = await DioConsumer(dio: dio).post(
        url: EndPoints.payMobAuth,
        data: {
          "api_key": EndPoints.payMobApikey,
        },
      );
      return response['token'];
    } catch (e) {
      throw Exception("Authentication failed: $e");
    }
  }

  Future<int> _createOrder(String token , int amount) async {
    try {
      final response = await DioConsumer(dio: dio).post(
        url: EndPoints.payMobOrder,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: {
          "auth_token": token,
          "delivery_needed": false,
          "amount_cents": (100*amount).toString(),
          "currency": "EGP",
          "items": []
        },
      );
      return response['id'];
    } catch (e) {
      throw Exception("Order creation failed: $e");
    }
  }

  Future<String> _generatePaymentKey(String token, int orderId, int amount) async {
    try {
      final response = await DioConsumer(dio: dio).post(
        url: EndPoints.paymentKeyUrl,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          "auth_token": token,
          "amount_cents": (100*amount).toString(),
          "expiration": 3600,
          "order_id": orderId,
          "billing_data": {
            "apartment": "803",
            "email": "test@example.com",
            "floor": "42",
            "first_name": "John",
            "street": "Example Street",
            "building": "8028",
            "phone_number": "+201234567890",
            "shipping_method": "PKG",
            "postal_code": "01898",
            "city": "Cairo",
            "country": "EG",
            "last_name": "Doe",
            "state": "Cairo"
          },
          "currency": "EGP",
          "integration_id": 5148370,
        },
      );
      return response['token'];
    } catch (e) {
      throw Exception("Payment key generation failed: $e");
    }
  }
}
