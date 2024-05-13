import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:minervaschool/SharedPref/pref_constants.dart';
import 'package:minervaschool/Screens/PreLoginScreens/login_screen.dart';

class TokenManager {
  late String _authToken = '';
  late String _userId = '';
  late String _studentId = '';
  late String _fullName = '';
  late String _sId = '';
  late String _id = '';
  late String _nowIn = '';
  static late TokenManager _instance;

  TokenManager._internal();

  factory TokenManager() {
    _instance = TokenManager._internal();
    return _instance;
  }

  //AuthToken

  Future<void> saveAuthToken(String authToken) async {
    _authToken = authToken;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', authToken);

    print('Stored Auth Token: $authToken');
  }

  Future<String?> getAuthToken() async {
    if (_authToken.isNotEmpty) {
      return _authToken;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<String?> getStoredAuthToken() async {
    String? authToken = await getAuthToken();
    if (authToken != null && authToken.isNotEmpty) {
      return authToken;
    }
    return null;
  }

  //UserID

  Future<void> saveUserId(String userId) async {
    _userId = userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);

    // Add this log statement
    print('Stored User ID: $userId');
  }

  Future<String?> getUserId() async {
    if (_userId.isNotEmpty) {
      return _userId;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Get User ID: $_userId');

    return prefs.getString('userId');
  }

  Future<String?> getStoredUserId() async {
    String? userId = await getUserId();
    print('getStoredUserId User ID: $userId'); // Add this log statement
    if (userId != null && userId.isNotEmpty) {
      // Decode the base64-encoded userId
      List<int> bytes = base64.decode(userId);
      String decodedUserId = utf8.decode(bytes);

      print('Decoded User ID: $decodedUserId');

      return decodedUserId;
    }
    return null;
  }

  //StudentID

  Future<void> saveStudentId(String studentId) async {
    _studentId = studentId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('studentId', studentId);

    // Add this log statement
    print('Stored studentId : $studentId');
  }

  Future<String?> getStudentId() async {
    if (_studentId.isNotEmpty) {
      return _studentId;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _studentId = prefs.getString('studentId') ?? '';

    print('Get student ID: $_studentId');

    return _studentId;
  }

  Future<String?> getStoredStudentId() async {
    String? studentId = await getStudentId();
    print(
        'getStoredStudentId Student ID: $studentId'); // Add this log statement
    if (studentId != null && studentId.isNotEmpty) {
      // Decode the base64-encoded studentId
      List<int> bytes = base64.decode(studentId);
      String decodedStudentId = utf8.decode(bytes);

      print('Decoded Student ID: $decodedStudentId');

      return decodedStudentId;
    }
    return null;
  }

  Future<void> saveFullName(String fullName) async {
    _fullName = fullName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);

    // Add this log statement
    print('Stored Full Name: $fullName');
  }

  Future<String?> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName');
  }

  // sId

  Future<void> saveSId(String sId) async {
    _sId = sId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sId', sId);

    // Add this log statement
    print('Stored sId: $sId');
  }

  Future<String?> getSId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sId');
  }

  // ID

  Future<void> saveId(String id) async {
    _id = id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);

    // Add this log statement
    print('Stored ID: $id');
  }

  Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("GET ID IS PRINTED HERE");
    print(prefs.getString('id'));
    return prefs.getString('id');
  }

  // Now In

  Future<void> saveNowIn(String nowIn) async {
    _nowIn = nowIn;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nowIn', nowIn);

    // Add this log statement
    print('Stored Now In: $nowIn');
  }

  Future<String?> getNowIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nowIn');
  }

  Future<void> saveStudents(List<Student> students) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert list of students to list of maps
    List<Map<String, dynamic>> studentsData = students
        .map((student) => {
              'fullName': student.fullName,
              'sId': student.sId,
              'id': student.id,
              'nowIn': student.nowIn,
            })
        .toList();

    String studentsJson = jsonEncode(studentsData);

    await prefs.setString(
        'students_data', studentsJson); // Use the string directly
  }

  Future<List<Student>> getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? studentsJson = prefs.getString('students_data');
    if (studentsJson == null) {
      return []; // Return an empty list if no data is stored
    }

    List<dynamic> studentsData = jsonDecode(studentsJson);
    List<Student> students = studentsData
        .map((data) => Student(
              fullName: data['fullName'],
              sId: data['sId'],
              id: data['id'],
              nowIn: data['nowIn'],
            ))
        .toList();

    return students;
  }
}
