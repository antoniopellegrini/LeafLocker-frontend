import 'package:fe_app/shared/http.dart';

class CellRepository {
  getCellPlants(String idCell) async {
    return await makeRequest(
      path: '/cell/$idCell/seeds',
      method: 'GET',
    );
  }

  rentCell(String idCell, String days) async {
    return await makeRequest(
      path: '/cell/$idCell/rent/start',
      method: 'POST',
      data: {'start': DateTime.now().millisecondsSinceEpoch.toString(), 'days': days},
    );
  }

  stopRentCell(String idCell) async {
    return await makeRequest(
      path: '/cell/$idCell/rent/stop',
      method: 'POST',
    );
  }

  getCellInfo(String idCell) async {
    return await makeRequest(
      path: '/cell/$idCell/info',
      method: 'GET',
    );
  }

  openCell(String idCell) async {
    return await makeRequest(
      path: '/cell/$idCell/open',
      method: 'POST',
    );
  }

  startCultuvation(String idCell, idSeed) async {
    return await makeRequest(path: '/cell/$idCell/cultivation/start', method: 'POST', data: {'seed_id': idSeed});
  }

  endCultivation(String idCell) async {
    return await makeRequest(path: '/cell/$idCell/cultivation/end', method: 'POST');
  }

  getCellInfoLeaf(String idCell, String token) async {
    return await makeLeafRequest(path: '/cell/$idCell/info', method: 'GET', data: {'token': token});
  }
}
