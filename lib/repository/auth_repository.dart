import 'package:fe_app/shared/http.dart';

class AuthRepository {
  login(String email, String password) async {
    return await makeRequest(
      path: '/login',
      method: 'POST',
      data: {'email': email, 'password': password},
    );
  }

  register(String email, String password, String firstname, String lastname, String phone) async {
    return await makeRequest(
      path: '/register',
      method: 'POST',
      data: {'email': email, 'password': password, 'firstname': firstname, 'lastname': lastname, 'phone': phone, 'role': 'user'},
    );
  }

  logout() async {
    return await makeRequest(
      path: '/logout',
      method: 'POST',
    );
  }

  refreshToken(refreshToken) async {
    return await makeRequest(
      path: '/refresh',
      method: 'POST',
      headers: {'Authorization': 'Bearer $refreshToken'},
    );
  }
}
