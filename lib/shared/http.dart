import 'package:dio/dio.dart';
import 'package:fe_app/blocs/auth/auth.dart';
import 'package:fe_app/blocs/loading/cubit/loading_cubit.dart';
import 'package:fe_app/config.dart';
import 'package:fe_app/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioInstance = Dio(
  BaseOptions(
    baseUrl: apiHost,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
);

final dioInstanceLeaf = Dio(
  BaseOptions(
    baseUrl: leafApiHost,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
);

updateAuthorizationHeaders(Dio instance, String accessToken) async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();

  // String? accessToken = preferences.getString('access_token');
  if (accessToken != null) {
    instance.options.headers['Authorization'] = 'Bearer $accessToken';
  }
}

attachInterceptor(instance, LoadingCubit loadingCubit, AuthBloc authBloc, AuthRepository authRepository) {
  instance.interceptors.add(
    InterceptorsWrapper(onRequest: (options, handler) async {
      loadingCubit.load();
      await Future.delayed(const Duration(milliseconds: 200));
      // Add the access token to the request header
      //options.heLeaders['Authorization'] = 'Bearer your_access_token';
      return handler.next(options);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      print("onResponse:");
      loadingCubit.stopLoading();
      // Do something with response data.
      // If you want to reject the request with a error message,
      // you can reject a `DioException` object using `handler.reject(dioError)`.
      return handler.next(response);
    }, onError: (DioException e, handler) async {
      print("onError:${e.response}");
      if (e.response?.statusCode == null) {
        loadingCubit.stopLoading();
        loadingCubit.showErrorUnreachable();
        return handler.next(e);
      }

      if (e.requestOptions.path.contains('logout')) {
        loadingCubit.stopLoading();
        loadingCubit.showError(e.response);
        return handler.reject(DioException(requestOptions: e.requestOptions, response: e.response));
      }
      if (e.requestOptions.path.contains('login') && e.response?.statusCode == 403) {
        loadingCubit.stopLoading();
        authBloc.add(AuthEventLogout());
        return handler.reject(DioException(requestOptions: e.requestOptions, response: e.response));
      }
      if (e.response?.statusCode == 401 && !e.requestOptions.path.contains('login')) {
        if (e.requestOptions.extra['retry'] == null) {
          var res = await authRepository.refreshToken(authBloc.state.refreshToken);

          if (res?.statusCode == 200) {
            String newAccessToken = res.data['access_token'];

            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString("access_token", newAccessToken);

            authBloc.add(AuthEventRefreshToken(newAccessToken: newAccessToken));

            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            e.requestOptions.extra['retry'] = true;

            updateAuthorizationHeaders(dioInstance, newAccessToken);

            // Repeat the request with the updated header
            return handler.resolve(await instance.fetch(e.requestOptions));
          }
        } else {
          loadingCubit.stopLoading();
          loadingCubit.showError(e.response);
          return handler.reject(DioException(requestOptions: e.requestOptions, response: e.response));
        }
      }
      loadingCubit.stopLoading();
      loadingCubit.showError(e.response);
      return handler.reject(DioException(requestOptions: e.requestOptions, response: e.response));
    }),
  );
}

makeRequest({required path, required method, data, params, headers}) async {
  try {
    final res = await dioInstance.request(path, options: Options(method: method, headers: headers), data: data, queryParameters: params);
    return res;
    //return {'statusCode': res.statusCode, 'message': res.statusMessage};
  } on DioException catch (e) {
    if (e.response != null) {
      return e.response;
    } else {
      return null;
    }
  }
}

makeLeafRequest({required path, required method, data, params, headers}) async {
  try {
    final res = await dioInstanceLeaf.request(path, options: Options(method: method, headers: headers), data: data, queryParameters: params);
    return res;
  } on DioException catch (e) {
    if (e.response != null) {
      return e.response;
    } else {
      return null;
    }
  }
}
