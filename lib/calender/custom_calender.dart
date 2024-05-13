import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minervaschool/calender/date_time_in_utils.dart';

import 'calender_month_data.dart';



/// About Calender view and Horizontal calender view
///
/// When use calender view pass 4 Argument --
/// @params Selected Month (selectedMonth)
/// @params Selected date (selectedMonth)
/// @params call back on date selected (selectDate)
/// @params get event list show in calender date (daysList)
/// @params call back on change month (onChange)
/// @params When Below calender list scroll list (scrollController)
///
/// when below calender list scroll show horizontal calender



class CalenderView extends StatefulWidget {
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;
  final List<CalenderList> daysList;
  final ValueChanged<DateTime> onChange;

  const CalenderView({super.key,
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
    required this.daysList,
    required this.onChange,
  });


  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  int isSelectedDate  = -1;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: widget.selectedMonth.year,
      month: widget.selectedMonth.month,
      statusList: widget.daysList,
    );

    // List<CalendarDayData> allDates = data.getDatesForMonth(widget.selectedMonth);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(height: 15,),
          buildCalenderView(data),
        ],
      ),
    );
  }

  /// calender widget
  AnimatedContainer buildCalenderView(CalendarMonthData data) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sun',style: TextStyle(fontSize: 12.0),),
                Text('Mon', style: TextStyle(fontSize: 12.0),),
                Text('Tue', style: TextStyle(fontSize: 12.0),),
                Text('Wed', style: TextStyle(fontSize: 12.0),),
                Text('Thu', style: TextStyle(fontSize: 12.0),),
                Text('Fri', style: TextStyle(fontSize: 12.0),),
                Text('Sat', style: TextStyle(fontSize: 12.0),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var week in data.weeks)
                Row(
                  children: week.map((d) {
                    return Expanded(
                      child: _RowItem(
                        hasRightBorder: false,
                        date: d.date,
                        isActiveMonth: d.isActiveMonth,
                        onTap: () => {
                          widget.selectDate(d.date),
                          debugPrint("selectedDate ${d.date}"),
                        },
                        isSelected: widget.selectedDate != null &&
                            widget.selectedDate!.isSameDate(d.date),
                        status: d.status,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Scroll listener function
  void _scrollListener() {
    setState(() {});
  }

}

/// calender item
class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.hasRightBorder,
    required this.isActiveMonth,
    required this.isSelected,
    required this.date,
    required this.onTap,
    required this.status,
  });

  final bool hasRightBorder;
  final bool isActiveMonth;
  final VoidCallback onTap;
  final bool isSelected;
  final bool status;

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final int number = date.day;
    final isToday = date.isToday;
    // final bool isPassed = date.isBefore(DateTime.now());

    Color textColor;
    Decoration? decoration;
    if (!isActiveMonth) {
      textColor = Colors.white; // Change this color as needed
      decoration = BoxDecoration(
        border: Border.all(color: Colors.transparent,),
      );
    } else if (isSelected) {
      textColor = Colors.white; // Change this color as needed
      decoration = const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(10)));
    }else if (status) {
      textColor = Colors.white; // Change this color as needed
      decoration = const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(10)));
    } else if (isToday) {
      textColor = Colors.black; // Change this color as needed
      decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.blue,),
      );
    }else {
      decoration = null;
      textColor = Colors.black;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 33,
        width: 40,
        margin: EdgeInsets.all(2),
        decoration: decoration,
        child: Text(
          number.toString(),
          style: TextStyle(
            fontFamily: "poppins_regular",
            fontSize: 12,
            color: textColor,
          ),
        ),
      ),
    );
  }
}





