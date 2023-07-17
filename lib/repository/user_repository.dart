import 'package:fe_app/shared/http.dart';

class UserRepository {
  getRentedLockersCellsList() async {
    return await makeRequest(path: '/user/rentedLockersCells', method: 'GET');
  }
}
