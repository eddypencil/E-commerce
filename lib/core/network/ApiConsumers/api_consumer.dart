abstract class ApiConsumer {
  Future<dynamic> get({
    String? url,
    Map<String, dynamic>? queryParameters,
  });
  Future<dynamic> post({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });
  Future<dynamic> patch({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });
  Future<dynamic> delete({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });
}
