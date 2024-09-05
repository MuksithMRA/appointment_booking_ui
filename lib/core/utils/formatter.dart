import 'package:intl/intl.dart';

class Formatter{

  static String formatDate(DateTime date){
    return DateFormat("dd MMM yyyy").format(date);
  }
}