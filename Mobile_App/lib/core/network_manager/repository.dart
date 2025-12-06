import 'package:kaashtkart/core/network_manager/api_response.dart';
import 'package:kaashtkart/core/network_manager/dio_helper.dart';
import 'package:kaashtkart/features/auth/model/customer_login_model.dart';
import 'package:kaashtkart/features/customer/screen/category/data/model/category_list_model.dart';


class Repository {
  final DioHelper _dioHelper = DioHelper();
  static const String baseUrl = "https://9h0vjqq5-5000.inc1.devtunnels.ms/api";


  //////// 👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉 CUSTOMER 👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉

  Future<ApiResponse<CustomerLoginModelResponse>> loginUser(Map<String, dynamic> requestBody,) async {
    final String url = "$baseUrl/user/login";

    try {
      final response = await _dioHelper.post<Map<String, dynamic>>(
        url: url,
        requestBody: requestBody,
        // isAuthRequired: false,
      );

      // ✅ Check actual API success flag from response data
      final bool apiSuccess = response.data?['success'] ?? false;

      if (response.success && response.data != null && apiSuccess) {
        return ApiResponse.success(CustomerLoginModelResponse.fromJson(response.data!));
      } else {
        return ApiResponse.error(
          response.data?['message'] ?? response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Login failed: ${e.toString()}");
    }
  }

  Future<ApiResponse<GetAllCategoryListModelResponse>> getAllDepartmentList() async {
    final String url = "$baseUrl/user/getcategory";

    try {
      final response = await _dioHelper.get<Map<String, dynamic>>(url: url);
      if (response.success && response.data != null) {
        return ApiResponse.success(GetAllCategoryListModelResponse.fromJson(response.data!),);
      } else {
        return ApiResponse.error(
          response.message ?? "Unknown error",
          statusCode: response.statusCode,
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse.error("Get All Branch failed: ${e.toString()}");
    }
  }

}