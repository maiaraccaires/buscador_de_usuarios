import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  DateFormat formatter = DateFormat('dd/MM/yy-hh:mm');
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}
