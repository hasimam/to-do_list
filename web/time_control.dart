// some helping functions with date and time

String dateStr = '';
const List _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const List _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
'Oct', 'Nov', 'Dec'];

int hours;
int minutes;
String seconds;

String getDate([DateTime time]) { // not used
  if (time == null) time = DateTime.now();
  dateStr = [_days[time.weekday - 1], _months[time.month - 1], time.day].join(' ');
  return dateStr;
}

String getTime([DateTime time]) {
  if (time == null) time = DateTime.now();
  hours = time.hour;
  minutes = time.minute;
  seconds = time.second.toString().padLeft(2, '0');
  dateStr = [_days[time.weekday - 1], _months[time.month - 1], time.day].join(' ');
  return "$dateStr, $hours:$minutes:$seconds";
}

int getTimeInMs() {
  return DateTime.now().millisecondsSinceEpoch;
}