import 'package:flutter/material.dart';
import 'package:kaashtkart/core/network_manager/api_response.dart';
import 'package:kaashtkart/core/network_manager/repository.dart';
import 'package:kaashtkart/core/state/async_state.dart';
import 'package:kaashtkart/core/utls/custom_snack_bar.dart';
import 'package:kaashtkart/core/utls/storage_helper.dart';
import 'package:kaashtkart/features/auth/model/customer_login_model.dart';
import 'package:kaashtkart/features/customer/screen/bottom_navigation/entrypoint_ui.dart';


class AuthApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  AsyncState<CustomerLoginModelResponse> _loginState = const AsyncState();
  AsyncState<CustomerLoginModelResponse> get loginState => _loginState;

  Future<void> loginUser(BuildContext context, Map<String, dynamic> body) async {
    _loginState = _loginState.loading();
    notifyListeners();

    try {
      final ApiResponse<CustomerLoginModelResponse> apiResponse =
      await _repository.loginUser(body);

      print('🔍 DEBUG: API Success Status = ${apiResponse.success}');
      print('🔍 DEBUG: API Data = ${apiResponse.data}');
      print('🔍 DEBUG: API Message = ${apiResponse.message}');

      // ✅ CRITICAL FIX: Strict success check
      if (apiResponse.success == true && apiResponse.data != null) {
        print('✅ Login SUCCESS - Navigating to home');

        _loginState = _loginState.success(apiResponse.data!);
        notifyListeners();

        await _saveUserData(apiResponse.data);

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: apiResponse.message ?? 'Login Successful!',
        );

        // Navigation ONLY on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerEntryPointUI()),
        );

      } else {
        print('❌ Login FAILED - Staying on login screen');
        _loginState = _loginState.failure(apiResponse.message ?? 'Login failed');
        notifyListeners();

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: apiResponse.message ?? 'Invalid email or password',
          backgroundColor: Colors.red,
        );
      }

    } catch (e) {
      print('❌ Exception caught: $e');
      _loginState = _loginState.failure("Something went wrong: $e");
      notifyListeners();

      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
      );
    }
  }


  Future<void> _saveUserData(CustomerLoginModelResponse? loginResponseModel) async {
    if(loginResponseModel?.user != null){
      final loginUserId = loginResponseModel?.user?.userId ?? "NA";
      final name = loginResponseModel?.user?.userName ?? "NA";
      final email = loginResponseModel?.user?.email ?? "NA";
      final phone = loginResponseModel?.user?.mobileNumber ?? "NA";

      await StorageHelper().setLoginUserId(loginUserId.toString());
      await StorageHelper().setLoginUserName(name);
      await StorageHelper().setLoginUserEmail(email);
      await StorageHelper().setLoginUserPhone(phone);
      await StorageHelper().setBoolIsLoggedIn(true);
    }
  }
}