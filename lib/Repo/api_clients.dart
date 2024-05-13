import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../Models/PreLoginModels/login_model.dart';

class APIProvider {
  final Dio _dio = Dio();
  final BASEURL = "https://mycampus.cloud/api/";
  //final BASEURL = "http://10.0.0.5/cle8/api/";
  // final BASEURL = "https://e8.stellarshell.com/api/";
  // final BASEURL = "http://ais.stellarshell.com/api/"; //P7067
  // final BASEURL = "https://mis.aisschools.com/api/";
  // final BASEURL = "http://lsq-e8.stellarshell.com/api/";

  APIProvider() {
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          error: true));
    }
  }

  Future<LoginModel> login(Map<String, dynamic> map, String token) async {
    var response = await _dio.post(BASEURL + "mobile2/login",
        data: map,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ));
    return LoginModel.fromJson(json.decode(response.toString()));
  }

  Future<LoginModel> logout(Map<String, dynamic> map, String token) async {
    var response = await _dio.post(BASEURL + "mobile2/logout",
        data: map,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ));
    return LoginModel.fromJson(json.decode(response.toString()));
  }

  Future<Response> fetchTimelineData(String token,
      {int pageNumber = 1, int pageSize = 80}) async {
    var response = await _dio.post(
      BASEURL + "mobile1/timeline",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response> fetchCirculars(
    String token, {
    int moduleId = 1,
    int pageNumber = 1,
    int pageSize = 20,
    required String userId,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile1/frontoffice",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'UserId': userId,
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response> fetchNews(
    String token, {
    int moduleId = 2,
    int pageNumber = 1,
    int pageSize = 20,
    required String? userId,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile1/frontoffice",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'UserId': userId,
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response> fetchEvents(
    String token, {
    int moduleId = 6,
    int pageNumber = 1,
    int pageSize = 20,
    required String userId,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile1/frontoffice",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'UserId': userId,
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response> fetchNewsletter(
    String token, {
    int moduleId = 5,
    int pageNumber = 1,
    int pageSize = 20,
    required String userId,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile1/frontoffice",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'UserId': userId,
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response> fetchLearningResources(String token,
      {int moduleId = 3,
      pageNumber = 1,
      int pageSize = 20,
      required String userId,
      required String studentId}) async {
    var response = await _dio.post(
      BASEURL + "mobile1/academics",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'UserId': userId,
        'StudentId': studentId,
      },
    );
    return response;
  }

  Future<Response> fetchTeacherNotes(String token,
      {int moduleId = 17,
      pageNumber = 1,
      int pageSize = 20,
      required String userId,
      required String studentId}) async {
    var response = await _dio.post(
      BASEURL + "mobile1/academics",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'UserId': userId,
        'StudentId': studentId,
      },
    );
    return response;
  }

  Future<Response> fetchAssessmentsData(String token,
      {int moduleId = 12,
      pageNumber = 1,
      int pageSize = 20,
      required String userId,
      required String studentId}) async {
    var response = await _dio.post(
      BASEURL + "mobile1/academics",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'ModuleId': moduleId.toString(),
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'UserId': userId,
        'StudentId': studentId,
      },
    );
    return response;
  }

  Future<Response> fetchResultData(String token,
      {int pageNumber = 1, int pageSize = 20}) async {
    var response = await _dio.post(
      BASEURL + "mobile2/result",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    var data = response.data;
    print("RESPONSE>DATA RESULT $data");
    return response;
  }

  Future<Response> fetchUpcomingHolidays(String token,
      {int pageNumber = 1, int pageSize = 20}) async {
    var response = await _dio.post(
      BASEURL + "mobile2/upcomingholidays",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response> fetchAttendance(String token,
      {int pageNumber = 1, int pageSize = 20}) async {
    var response = await _dio.post(
      BASEURL + "mobile2/attendance/11",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response> fetchTransportData(String token,
      {int pageNumber = 1, int pageSize = 20}) async {
    var response = await _dio.post(
      BASEURL + "mobile2/transport/Mzg=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    return response;
  }

  Future<Response<dynamic>> fetchhomework({
    required String token,
    required String studentId,
    required Map<String, dynamic> data,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/homeworks",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'data': data,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return response;
  }

  Future<Response<dynamic>> fetchAppointment({
    required String? token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/appointment",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    return response;
  }

  //WELL BEING
  Future<Response<dynamic>> fetchOPD({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDc=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchVaccine({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDk=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchHealthIssues({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDQ=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchHealthCheckup({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDg=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchFoodAlergy({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDU=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchPhysicalStats({
    required String? token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/healthcontent/NDY=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  //CONDUCT AND BEHAVIOUR
  Future<Response<dynamic>> fetchIncidents({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/behaviourcontent/NTA=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchGoodNews({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/behaviourcontent/NTE=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  // Future<Response<dynamic>> fetchCharacterTraits({
  //   required String? token,
  // }) async {
  //   var response = await _dio.post(
  //     BASEURL + "mobile2/behaviourcontent/NTI=",
  //     options: Options(
  //       headers: {"Authorization": "Bearer $token"},
  //     ),
  //     data: {},
  //   );
  //   return response;
  // }

  Future<Map<String, dynamic>> fetchCharacterTraits({
    required String? token,
  }) async {
    try {
      var response = await _dio.post(
        BASEURL + "mobile2/behaviourcontent/NTI=",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        data: {},
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Extract the response data using the `data` field
        final responseData = response.data;

        // Return the response data
        return responseData;
      } else {
        // Handle HTTP error responses
        print('Failed to fetch characterTraits: ${response.statusCode}');
        throw Exception(
            'Failed to fetch characterTraits: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error fetching characterTraits: $error');
      throw Exception('Error fetching characterTraits: $error');
    }
  }

  //LIBRARY
  Future<Response<dynamic>> fetchLibraryBorrowed({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/library/NDE=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchLibraryReturned({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/library/NDI=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchLibraryBooklist({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/library/NDM=",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  //RE-REGISTERATION
  Future<Response<dynamic>> fetchReRegisterationList({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/BindReRegListContent",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchReRegisterationTermsandCondition({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/BindReRegTCContent",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }

  Future<Response<dynamic>> fetchSaveReRegisteration({
    required String token,
    required String studentId,
    required String prevSessionId,
    required String toGradeId,
    required String schoolId,
    required bool enableTransport,
    required bool reEnroll,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/ReregistrationSave",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {
        'studentId': studentId,
        'prevSessionId': prevSessionId,
        'toGradeId': toGradeId,
        'schoolId': schoolId,
        'enableTransport': enableTransport,
        'reEnroll': reEnroll,
      },
    );
    return response;
  }

  //GATE SECURITY
  Future<Response<dynamic>> fetchGatePass({
    required String token,
  }) async {
    var response = await _dio.post(
      BASEURL + "mobile2/gatesecuritycontent",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
      data: {},
    );
    return response;
  }
}
