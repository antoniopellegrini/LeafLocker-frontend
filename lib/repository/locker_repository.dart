import 'package:fe_app/shared/http.dart';

class LockerRepository {
  getLockersList() async {
    return await makeRequest(path: '/lockers', method: 'GET', params: {'free': true});
  }

  getLockerFreeCells(String idLocker) async {
    return await makeRequest(path: '/locker/$idLocker/cells', method: 'GET', params: {'free': true});
  }
}
