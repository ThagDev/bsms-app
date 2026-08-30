import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '--/--/---- --:--';
    return _dateTimeFormat.format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '--:--';
    return _timeFormat.format(date);
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          return DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  /// Trả về màu sắc tương ứng cho trạng thái Ticket
  static Color getTicketStatusColor(String? status) {
    final s = status?.toLowerCase().trim() ?? '';
    if (s.contains('mới') || s.contains('new') || s.contains('open') || s.contains('chờ')) {
      return const Color(0xFFF59E0B); // Amber
    } else if (s.contains('xử lý') || s.contains('in progress') || s.contains('đang')) {
      return const Color(0xFF3B82F6); // Blue
    } else if (s.contains('hoàn thành') || s.contains('done') || s.contains('resolved') || s.contains('đóng')) {
      return const Color(0xFF10B981); // Green
    } else if (s.contains('hủy') || s.contains('cancel') || s.contains('từ chối')) {
      return const Color(0xFF6B7280); // Grey
    } else if (s.contains('khẩn') || s.contains('urgent') || s.contains('quá hạn')) {
      return const Color(0xFFEF4444); // Red
    }
    return const Color(0xFF0F3057);
  }

  /// Trả về màu sắc tương ứng cho trạng thái ATM
  static Color getAtmStatusColor(String? status) {
    final s = status?.toLowerCase().trim() ?? '';
    if (s.contains('hoạt động') || s.contains('active') || s.contains('online')) {
      return const Color(0xFF10B981);
    } else if (s.contains('sự cố') || s.contains('lỗi') || s.contains('offline') || s.contains('hỏng')) {
      return const Color(0xFFEF4444);
    } else if (s.contains('bảo trì') || s.contains('maintenance')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF6B7280);
  }
}
