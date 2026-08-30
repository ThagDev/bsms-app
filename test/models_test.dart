import 'package:flutter_test/flutter_test.dart';
import 'package:bsms_flutter/data/models/ticket_model.dart';
import 'package:bsms_flutter/data/models/atm_model.dart';
import 'package:bsms_flutter/data/models/user_model.dart';
import 'package:bsms_flutter/data/models/server_config_model.dart';

void main() {
  group('Data Models & Serialization Tests', () {
    test('TicketModel parses from JSON correctly and handles SLA overdue', () {
      final json = {
        'ticketId': 'TK_999',
        'ticketNo': 'TKT-2026-9999',
        'title': 'Kẹt tiền khay nạp CDM',
        'content': 'Khách hàng nạp tiền mệnh giá 500k',
        'status': 'Đang xử lý',
        'priority': 'Khẩn cấp',
        'atmCode': 'VCB-001',
        'customerName': 'Vietcombank',
        'slaDueDate': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      };

      final ticket = TicketModel.fromJson(json);

      expect(ticket.ticketId, equals('TK_999'));
      expect(ticket.ticketNo, equals('TKT-2026-9999'));
      expect(ticket.isSlaOverdue, isTrue);

      final dbMap = ticket.toDbMap();
      expect(dbMap['ticket_id'], equals('TK_999'));
      expect(dbMap['status'], equals('Đang xử lý'));
    });

    test('AtmModel parses and handles coordinates', () {
      final json = {
        'atmId': 'ATM_99',
        'atmCode': 'BIDV-HN-01',
        'lat': '21.0285',
        'lng': '105.8542',
        'status': 'Hoạt động',
      };

      final atm = AtmModel.fromJson(json);
      expect(atm.atmId, equals('ATM_99'));
      expect(atm.lat, equals(21.0285));
      expect(atm.lng, equals(105.8542));
      expect(atm.status, equals('Hoạt động'));
    });

    test('ServerConfig generates correct endpoint URLs', () {
      const config = ServerConfig(
        ip: '115.78.3.210',
        port: 8082,
        useHttps: false,
        customEndpoint: '/MobiFunc/Mobi.aspx',
      );

      expect(config.baseUrl, equals('http://115.78.3.210:8082'));
      expect(config.fullEndpointUrl, equals('http://115.78.3.210:8082/MobiFunc/Mobi.aspx'));
      expect(config.uploadUrl, equals('http://115.78.3.210:8082/MobiFunc/uploadfile.aspx'));
    });

    test('UserModel identifies leader role correctly', () {
      final user1 = UserModel.fromJson({
        'userId': '1',
        'username': 'tech01',
        'fullName': 'Tech One',
        'role': 'Kỹ thuật viên',
      });
      expect(user1.isLeader, isFalse);

      final user2 = UserModel.fromJson({
        'userId': '2',
        'username': 'leader01',
        'fullName': 'Leader One',
        'role': 'Trưởng nhóm kỹ thuật (Leader)',
      });
      expect(user2.isLeader, isTrue);
    });
  });
}
