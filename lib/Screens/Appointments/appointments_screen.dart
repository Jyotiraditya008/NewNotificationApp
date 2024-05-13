import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minervaschool/Screens/DashBoardScreen/token_provider.dart';
import 'dart:async';
import 'package:minervaschool/Repo/api_clients.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<dynamic> OldappointmentList = [];
  List<dynamic> NewappointmentList = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final apiProvider = APIProvider();
      String? savedToken = await TokenManager().getStoredAuthToken();

      final response = await apiProvider.fetchAppointment(token: savedToken);

      if (response.statusCode == 200) {
        setState(() {
          OldappointmentList = response.data['data']['pastAppointments'];
        });

        // Print response data
        print('Response data appointment: ${response.data}');
      } else {
        print('Failed to fetch appointments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          body: Column(
            children: [
              TabBar(
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "NEW",
                  ),
                  Tab(
                    text: "PAST",
                  )
                ],
                labelStyle: const TextStyle(
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAppointmentsList(NewappointmentList),
                    _buildAppointmentsList(OldappointmentList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(List<dynamic> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Text(
          "Can't see any appointments",
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromARGB(255, 96, 96, 96),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final appointment = appointments[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFe9e9e9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 80,
                              width: 80,
                              // You can replace the placeholder image with the actual image from the API response
                              child: WavyEdgeCircle(
                                size: 200,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment['sTitle'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    appointment['sDate'] ?? 'No Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        // You can replace the placeholder image with the actual image from the API response
                                        "assets/images/ic_location.png",
                                        height: 15,
                                        color: Colors.redAccent,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          appointment['scName'] ??
                                              'No Location',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            appointment['status'] == 1
                                ? 'Appointment Pending'
                                : 'Appointment Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: appointment['status'] == 1
                              ? Colors.red
                              : Colors.green,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: appointments.length,
          ),
        ),
      ],
    );
  }
}

class WavyEdgeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const WavyEdgeCircle({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WavyEdgeCirclePainter(color: color),
    );
  }
}

class _WavyEdgeCirclePainter extends CustomPainter {
  final Color color;

  _WavyEdgeCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final waveAmplitude = 10.0;
    final waveFrequency = 0.05;

    path.moveTo(size.width, size.height / 2);
    for (double i = size.width; i >= 0; i -= 0.5) {
      final x = i;
      final y = sin((size.width - i) * waveFrequency) * waveAmplitude +
          size.height / 2;
      path.lineTo(x, y);
    }
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
