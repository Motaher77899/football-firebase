// ============================================================================
// APP DATE UTILS - TIMEZONE FIX FOR FIREBASE TIMESTAMPS
// ============================================================================
// File: lib/utils/date_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  // ✅ Parse Firestore Timestamp without timezone shift
  static DateTime parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) {
      final utcDate = value.toDate();

      // ✅ CRITICAL: Keep same date values, don't convert timezone
      return DateTime(
        utcDate.year,
        utcDate.month,
        utcDate.day,
        utcDate.hour,
        utcDate.minute,
        utcDate.second,
      );
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  // ✅ Parse date only (ignore time, set to midnight)
  static DateTime parseDateOnly(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) {
      final utcDate = value.toDate();
      return DateTime(utcDate.year, utcDate.month, utcDate.day, 0, 0, 0);
    }

    if (value is DateTime) {
      return DateTime(value.year, value.month, value.day, 0, 0, 0);
    }

    if (value is String) {
      try {
        final parsed = DateTime.parse(value);
        return DateTime(parsed.year, parsed.month, parsed.day, 0, 0, 0);
      } catch (e) {
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  // ✅ Format date for display (Bengali)
  static String formatBengaliDate(DateTime date) {
    final day = date.day;
    final month = _getBengaliMonth(date.month);
    final year = date.year;

    return '$day $month $year';
  }

  // ✅ Format date with time (Bengali)
  static String formatBengaliDateTime(DateTime date) {
    final dateStr = formatBengaliDate(date);
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$dateStr, $hour:$minute $period';
  }

  // ✅ Format date range (Bengali)
  static String formatBengaliDateRange(DateTime start, DateTime end) {
    final startDay = start.day;
    final endDay = end.day;
    final startMonth = _getBengaliMonth(start.month);
    final endMonth = _getBengaliMonth(end.month);
    final year = end.year;

    if (start.month == end.month) {
      return '$startDay - $endDay $endMonth $year';
    } else {
      return '$startDay $startMonth - $endDay $endMonth $year';
    }
  }

  // ✅ Format time only (Bengali)
  static String formatBengaliTime(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  // ✅ Get Bengali month name
  static String _getBengaliMonth(int month) {
    const months = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল',
      'মে', 'জুন', 'জুলাই', 'আগস্ট',
      'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    return months[month - 1];
  }

  // ✅ Convert DateTime to Firestore Timestamp
  static Timestamp toTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }

  // ✅ Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} দিন আগে';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} মিনিট আগে';
    } else {
      return 'এখনই';
    }
  }
}
