import 'package:kaashtkart/core/network_manager/api_response.dart';
import 'package:kaashtkart/core/network_manager/dio_helper.dart';
import 'package:kaashtkart/features/customer/screen/category/data/model/category_list_model.dart';


class Repository {
  final DioHelper _dioHelper = DioHelper();
  static const String baseUrl = "https://kk.codecrafter.co.in/api";

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
