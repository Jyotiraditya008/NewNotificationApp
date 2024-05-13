import 'package:minervaschool/Repo/api_clients.dart';

import '../Models/PreLoginModels/login_model.dart';

class ApiRepository {
  final APIProvider _apiProvider = APIProvider();

  Future<LoginModel> login(Map<String, dynamic> map, String token) async {
    return _apiProvider.login(map, token);
  }

  Future<LoginModel> logout(Map<String, dynamic> map, String token) async {
    return _apiProvider.logout(map, token);
  }
}
