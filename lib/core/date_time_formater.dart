
import 'dart:developer';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
class DateTimeFormatter{

  static String convert24To12(String time24) {
    // Split the input time into hours and minutes
    List<String> parts = time24.split(':');
    int hour = int.parse(parts[0]);
    String minutes = parts[1];

    // Determine AM or PM
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert hour from 24-hour to 12-hour format
    hour = hour % 12;
    // Handle the case for midnight
    hour = hour == 0 ? 12 : hour;

    // Format the hour to ensure it's two digits
    String hourFormatted = hour.toString().padLeft(2, '0');

    // Return the formatted time
    return '$hourFormatted:$minutes $period';
  }
 static DateTime parseTimeStringToDateTime(String timeString) {
    DateFormat format = DateFormat("HH:mm:ss");
    return format.parse(timeString);
  }
  static String amFormat(String dateTime){

    return DateFormat("hh:mm a").format(DateTime.parse(dateTime));
  }
  static String hmsFormat(String dateTime){

    return DateFormat.jm().format(
        DateFormat("hh:mm:ss")
            .parse(dateTime));
  }
  static String stringToFullDateTime(String dateTime){

    return DateFormat("d MMMM hh:mm a").format(DateTime.parse(dateTime));
  }
  static String dateTimeToFullDateTime(DateTime time){
    return  DateFormat("d MMMM hh:mm a","ar_SA").format(time);
  }


  static String dateTimeToAPIDate(DateTime time){
    return  DateFormat("yyyy-MM-dd").format(time);
  }
  static String dateTimeToAPITime(DateTime time){
    return  DateFormat("hh:mm:ss").format(time);
  }
  static String dateTimeToFullDate(DateTime time){

    return DateFormat("d MMMM y","ar_SA").format(time);
  }
  static String dateTimeToAMPM(DateTime time){

    return DateFormat("hh:mm a","ar_SA").format(time);
  }
  static String dateTimeToFullDateMDY(DateTime time){

    return DateFormat("MMMM d, y").format(time);
  }
  static String fullWeekNameFromDateTime(DateTime time){

    return DateFormat("EEEE").format(time);
  }
  static String fullWeekNameFromStringDateTime(String dateTime){

    return DateFormat("EEEE").format(DateTime.parse(dateTime));
  }



}