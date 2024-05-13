import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minervaschool/Common/student_info_list.dart';
import 'package:minervaschool/Repo/api_clients.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'package:http/http.dart' as http;

class CharacterTraits extends StatefulWidget {
  final String? stId; // Define a parameter to hold the stId value

  const CharacterTraits({Key? key, this.stId}) : super(key: key);

  @override
  State<CharacterTraits> createState() => _CharacterTraitsState();
}

class _CharacterTraitsState extends State<CharacterTraits> {
  final ScrollController _controller = ScrollController();
  List<dynamic> charactertraits = [];
  String? currentStudentId;

  @override
  void initState() {
    super.initState();
    fetchCharacterTraits(
        widget.stId); // Call fetchCharacterTraits with the initial stId
  }

  @override
  void didUpdateWidget(CharacterTraits oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Call fetchCharacterTraits whenever the stId changes
    if (widget.stId != oldWidget.stId) {
      fetchCharacterTraits(widget.stId);
    }
  }

  Future<void> fetchCharacterTraits(String? studentId) async {
    try {
      final apiProvider = APIProvider();
      String? savedToken = await TokenManager().getStoredAuthToken();

      final responseData =
          await apiProvider.fetchCharacterTraits(token: savedToken);

      // Process the response data
      processResponseData(responseData);
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error fetching characterTraits: $error');
    }
  }

  void processResponseData(Map<String, dynamic> responseData) {
    setState(() {
      if (responseData.containsKey('data')) {
        charactertraits = responseData['data'];
        print('characterTraitsData in list: $charactertraits');
        // Assuming there's only one student's data in the list for now
        if (charactertraits.isNotEmpty) {
          currentStudentId = charactertraits.first['stId'];
          print('Current Student ID: $currentStudentId');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Received Student ID from StudentInfoList: ${widget.stId}');
    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF974889),
        title: const Text(
          'Character Traits',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StudentInfoList(
              onStudentChanged: (studentId) {
                setState(() {
                  currentStudentId = studentId;
                  print('Selected Student ID: $currentStudentId');
                  fetchCharacterTraits(
                      currentStudentId); // Fetch data for the selected student
                });
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: const Color(0xFFe9e9e9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Term 1",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Aug 28, 2023 - Dec 15,2023",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: charactertraits.length,
                itemBuilder: (context, index) {
                  final studentData = charactertraits[index];

                  // Check if 'data' is not null and not empty
                  if (studentData['data'] != null &&
                      studentData['data'].isNotEmpty) {
                    final data = studentData['data'][0];

                    // Check if 'characterTraitsDetails' is not null
                    if (data['characterTraitsDetails'] != null) {
                      final characterTraitsDetails =
                          data['characterTraitsDetails'];

                      // Now you can use characterTraitsDetails safely
                      return Column(
                        children: [
                          for (final detail in characterTraitsDetails)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    detail['characteristicName'] ??
                                        'Unknown Characteristic',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    detail['expectationName'] ??
                                        'Unknown Expectation',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
