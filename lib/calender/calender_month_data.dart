import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_time_in_utils.dart';

class CalendarMonthData {
  final int year;
  final int month;
  final List<CalenderList> statusList;

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);
  int get firstDayOfWeekIndex => 0;
  int get weeksCount => ((daysInMonth + firstDayOffset) / 7).ceil();

  CalendarMonthData({
    required this.year,
    required this.month,
    required this.statusList,
  });

  int get firstDayOffset {
    final int weekdayFromMonday = DateTime(year, month).weekday;
    final offset = (weekdayFromMonday - ((firstDayOfWeekIndex - 1) % 7)) % 7 - 1;
    return offset;
  }


  List<List<CalendarDayData>> get weeks {
    final res = <List<CalendarDayData>>[];
    var firstDayMonth = DateTime(year, month, 1);
    var firstDayOfWeek = firstDayMonth.subtract(Duration(days: firstDayOffset));

    for (var w = 0; w < weeksCount; w++) {
      final week = List<CalendarDayData>.generate(7, (index) {
        final date = firstDayOfWeek.add(Duration(days: index));
        final isActiveMonth = date.year == year && date.month == month;

        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        final status = statusList.any((status) => status.date.toString().contains(formattedDate));

        return CalendarDayData(
          date: date,
          isActiveMonth: isActiveMonth,
          isActiveDate: date.isToday,
          status: status,
        );
      });

      res.add(week);
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    }
    return res;
  }

  List<CalendarDayData> getDatesForMonth(DateTime sMonth) {
    final res = <CalendarDayData>[];
    final firstDay = DateTime(sMonth.year, sMonth.month, 1);


    final statusSet = statusList.map((status) => status.date.toString()).toSet();

    for (int i = 0; i < daysInMonth; i++) {
      final currentDate = firstDay.add(Duration(days: i));

      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDate);
      final isActiveMonth = currentDate.year == year && currentDate.month == month;
      final status = statusSet.contains(formattedDate);

      res.add(CalendarDayData(
        date: currentDate,
        isActiveDate: sMonth.isToday,
        isActiveMonth: isActiveMonth,
        status: status,
      ));
    }
    return res;
  }
}
