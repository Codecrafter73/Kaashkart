// auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:kaashtkart/core/utls/storage_helper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add the API key header for all requests
    // options.headers['x-api-key'] = 'ayush_don_123';

    // Conditionally add the userId header
    final userId = StorageHelper().getLoginUserId();
    if (userId.isNotEmpty) {
      options.headers['userId'] = userId;
    }

    return handler.next(options);
  }
}