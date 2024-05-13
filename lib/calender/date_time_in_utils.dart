

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, day);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

// Function to check if two DateTime objects represent the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool isSameDate(DateTime firstTime,DateTime secondTime) {
  return firstTime.year == secondTime.year && firstTime.month == secondTime.month;
}

// bool isSameDateCheck(int index ,List<TodoModel>  data) {
//   if(index == 0){
//     return true;
//   }else{
//     final firstTime = DateTime.parse(data[index].dateTime);
//     final secondTime = DateTime.parse(data[index-1].dateTime);
//     return firstTime.day != secondTime.day;
//   }
// }


class CalendarDayData {
  final DateTime date;
  final bool isActiveMonth;
  final bool isActiveDate;
  final bool status;

  const CalendarDayData({
    required this.date,
    required this.isActiveMonth,
    required this.isActiveDate,
    required this.status,
  });
}

class CalenderList {
  final String date;

  const CalenderList({
    required this.date,
  });
}