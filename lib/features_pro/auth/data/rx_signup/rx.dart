// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lsebert/helpers/toast.dart';
import 'package:lsebert/networks/dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../networks/rx_base.dart';
import '../../model/signup_response.dart';
import 'api.dart';

final class PostSignUpRX extends RxResponseInt {
  final api = SignUpApi.instance;

  PostSignUpRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;
  String message = "";
  Future<bool> signup({
    required String firstName,
    required String email,
    required String password,
    required String password_confirmation,
    required String role,
    required bool termAccepted,
    required String profession,
  }) async {
    try {
      Map data = await api.signUp(
          firstName: firstName,
          email: email,
          password: password,
          phone: password_confirmation,
          role: role,
          profession: profession,
          termAccepted: termAccepted);
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    SignUpResponse _signUpRes = SignUpResponse.fromJson(data);

    if (_signUpRes.success!) {
      String accesstoken = _signUpRes.data!.token!;
      String userType = _signUpRes.data!.user!.role!;
      await appData.write(kKeyAccessToken, accesstoken);
      await appData.write(kKeyUserType, userType);
      DioSingleton.instance.update(accesstoken);
      dataFetcher.sink.add(data);
      message = _signUpRes.message!;
      ToastUtil.showLongToast(message);
      NavigationService.navigateToReplacement(Routes.otpVerify);
      return true;
    } else {
      return false;
    }
  }

  @override
  handleErrorWithReturn(error) {
    log(error.runtimeType.toString());
    DioException exception = error as DioException;
    log(exception.message.toString());
    message = exception.response!.data["message"];
    ToastUtil.showLongToast(message);
    dataFetcher.sink.addError(error);
    return false;
  }
}
