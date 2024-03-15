import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

/// A class through which all methods can be statically accessed.
class KeepSabbath {
  /// Get the sunset time of the given day at [lat] and [lng]
  static DateTime getSunsetTime(DateTime day, double lat, double lng) {
    var sunInfo = getSunriseSunset(lat, lng, const Duration(hours: 1), day);
    return sunInfo.sunset;
  }

  /// Get the number of the day of the week.
  /// "Monday" is 1
  static int whatWeekday(DateTime today) {
    return today.weekday;
  }

  /// Whether it is before, during, or after the Biblical day.
  static bool isDuringBiblicalDay(
      DateTime now, DateTime dayStarts, DateTime dayEnds) {
    if (dayStarts.compareTo(now) < 0) {
      // We know the day has started
      //return true;
      if (dayEnds.compareTo(now) < 0) {
        // It is after the day now
        return false;
      } else {
        // It is still during the day
        return true;
      }
    } else if (dayStarts.compareTo(now) > 0) {
      // It is before the day
      return false;
    } else {
      // This should never happen... :)
      return false;
    }
  }

  /// Get the beginning and ending times of the day (sunset to sunset).
  static Map<String, DateTime> getDayBeginsEnds(
      DateTime priorDay, DateTime day, double lat, double lng) {
    // Calculate sunrise and sunset
    DateTime priorDaySunset = getSunsetTime(priorDay, lat, lng);
    DateTime daySunset = getSunsetTime(day, lat, lng);

    // log("Day will begin at $priorDaySunset");
    // log("Day will end at $daySunset");

    return {'begins': priorDaySunset, 'ends': daySunset};
  }

  /// Calculate whether today is the Sabbath or not with the given [lat] and [lng].
  /// This should not be used directly. Use the more optimized `isSabbath` method instead.
  static bool getIsSabbath(int weekday, double lat, double lng) {
    //final override = DateTime(2023, 8, 26, 9, 0, 0);
    DateTime now = DateTime.now();
    DateTime revSabbathDay = DateTime.now();
    DateTime sabbathDay = DateTime.now();

    // The 6th day (rev Sabbath, the evening when the Sabbath starts).
    if (weekday == 5) {
      sabbathDay = sabbathDay.add(const Duration(days: 1));
      // The 7th day (the Sabbath)
    } else if (weekday == 6) {
      revSabbathDay = revSabbathDay.subtract(const Duration(days: 1));
    }

    Map<String, DateTime> sabbathTimes =
        getDayBeginsEnds(revSabbathDay, sabbathDay, lat, lng);
    return isDuringBiblicalDay(
        now, sabbathTimes['begins']!, sabbathTimes['ends']!);
  }

  /// Get whether the current day and time is the Sabbath or not.
  /// This is based on an understanding that the Sabbath day starts
  /// at sundown Fri. and ends at sundown Sat.
  static bool isSabbath(double lat, double lng) {
    // See if it is currently the 6th or 7th day (Fri. or Sat.)
    DateTime now = DateTime.now();
    int weekday = whatWeekday(now);

    // This is a slight performance optimization:
    // It will only calculate the Sabbath times if it
    // is near the Sabbath day (rev-Shabbat) or the day-of.
    if (weekday == 5 || weekday == 6) {
      return getIsSabbath(weekday, lat, lng);
    } else {
      return false;
    }
  }

  /// Get whether the current day and time is a Holy Day in [holyDays].
  static bool isHolyDay(List<DateTime> holyDays, double lat, double lng) {
    DateTime now = DateTime.now();

    for (var holyDay in holyDays) {
      DateTime revDay = holyDay.copyWith();
      revDay = revDay.subtract(const Duration(days: 1));

      // Only calculate the sunset times if the day and month actually match
      if ((now.month == revDay.month && now.day == revDay.day) ||
          (now.month == holyDay.month && now.day == holyDay.day)) {
        Map<String, DateTime> holyDayTimes =
            getDayBeginsEnds(revDay, holyDay, lat, lng);
        if (isDuringBiblicalDay(
            now, holyDayTimes['begins']!, holyDayTimes['ends']!)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Get whether the current day and time is the Sabbath or a Holy day.
  static bool isSabbathOrHolyDay(
      List<DateTime> holyDays, double lat, double lng) {
    bool isSabbathDay = isSabbath(lat, lng);
    if (isSabbathDay == true) {
      return true;
    } else {
      return isHolyDay(holyDays, lat, lng);
    }
  }
}
