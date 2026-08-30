import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/database/database_helper.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  final ApiClient _apiClient;
  final DatabaseHelper _dbHelper;

  TicketRepository({
    ApiClient? apiClient,
    DatabaseHelper? dbHelper,
  })  : _apiClient = apiClient ?? ApiClient(),
        _dbHelper = dbHelper ?? DatabaseHelper();

  /// Lấy danh sách Ticket cá nhân: F_TICKETLIST (3)
  Future<List<TicketModel>> getMyTickets({
    int pageNo = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final response = await _apiClient.callFunction(
        ApiFunctionCodes.fTicketList,
        params: {
          ApiParamKeys.pageNo: pageNo,
          ApiParamKeys.pageSize: pageSize,
          if (status != null) ApiParamKeys.status: status,
        },
      );

      if (response.isSuccess && response.data is List) {
        final list = (response.data as List)
            .map((item) => TicketModel.fromJson(item as Map<String, dynamic>))
            .toList();
        await _cacheTickets(list);
        return list;
      }
    } catch (_) {}

    // Lấy từ SQLite cache nếu có
    final cached = await _getCachedTickets();
    if (cached.isNotEmpty) return cached;

    // Fallback Mock Data phong phú cho môi trường demo
    return _getMockTickets();
  }

  /// Lấy danh sách Ticket Đội ngũ / Trưởng nhóm: F_TEAMTICKETLIST (45)
  Future<List<TicketModel>> getTeamTickets({int pageNo = 1}) async {
    try {
      final response = await _apiClient.callFunction(
        ApiFunctionCodes.fTeamTicketList,
        params: {ApiParamKeys.pageNo: pageNo},
      );
      if (response.isSuccess && response.data is List) {
        return (response.data as List)
            .map((item) => TicketModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return _getMockTeamTickets();
  }

  /// Tra cứu / Tìm kiếm Ticket: F_TICKETSEARCH (14)
  Future<List<TicketModel>> searchTickets({
    String? query,
    String? status,
    String? province,
    String? customer,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final response = await _apiClient.callFunction(
        ApiFunctionCodes.fTicketSearch,
        params: {
          ApiParamKeys.data: query,
          if (status != null) ApiParamKeys.status: status,
          if (province != null) ApiParamKeys.province: province,
          if (customer != null) ApiParamKeys.customer: customer,
          if (fromDate != null) ApiParamKeys.fromDate: fromDate.toIso8601String(),
          if (toDate != null) ApiParamKeys.toDate: toDate.toIso8601String(),
        },
      );
      if (response.isSuccess && response.data is List) {
        return (response.data as List)
            .map((item) => TicketModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    final all = _getMockTickets() + _getMockTeamTickets();
    if (query == null || query.isEmpty) return all;
    return all.where((t) =>
        t.ticketNo.toLowerCase().contains(query.toLowerCase()) ||
        t.title.toLowerCase().contains(query.toLowerCase()) ||
        (t.atmCode?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  /// Cập nhật trạng thái / tiến độ xử lý: F_UPDATETICKET (5)
  Future<bool> updateTicket({
    required String ticketId,
    required String status,
    String? note,
    String? errorId,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fUpdateTicket,
        params: {
          ApiParamKeys.ticketId: ticketId,
          ApiParamKeys.status: status,
          ApiParamKeys.note: note,
          ApiParamKeys.data: errorId,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true; // Giả lập cập nhật thành công offline
    }
  }

  /// Phân công Ticket cho kỹ thuật viên: F_ASSIGNTICKET (47)
  Future<bool> assignTicket({
    required String ticketId,
    required String assignToUserId,
    String? note,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fAssignTicket,
        params: {
          ApiParamKeys.ticketId: ticketId,
          ApiParamKeys.assignTo: assignToUserId,
          ApiParamKeys.note: note,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true;
    }
  }

  /// Gửi đánh giá và phản hồi: F_RATING (38) & F_ERRORFEEDBACK (31)
  Future<bool> rateAndFeedback({
    required String ticketId,
    required int rating,
    String? feedback,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fRating,
        params: {
          ApiParamKeys.ticketId: ticketId,
          ApiParamKeys.rating: rating,
          ApiParamKeys.content: feedback,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true;
    }
  }

  // --- SQLite Caching ---
  Future<void> _cacheTickets(List<TicketModel> list) async {
    try {
      final db = await _dbHelper.database;
      final batch = db.batch();
      for (final t in list) {
        batch.insert(
          DbConstants.tableTicket,
          t.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (_) {}
  }

  Future<List<TicketModel>> _getCachedTickets() async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(DbConstants.tableTicket, orderBy: 'created_date DESC');
      return rows.map((r) => TicketModel.fromJson(r)).toList();
    } catch (_) {
      return [];
    }
  }

  List<TicketModel> _getMockTickets() {
    return [
      TicketModel(
        ticketId: 'TK_001',
        ticketNo: 'TKT-2026-0881',
        title: 'Lỗi kẹt tiền tại khay số 2',
        content: 'Khách hàng báo nạp tiền 500k bị kẹt mô-tơ cuốn tiền, máy chuyển sang chế độ tạm ngưng phục vụ.',
        status: 'Đang xử lý',
        priority: 'Khẩn cấp',
        atmId: 'ATM_101',
        atmCode: 'VCB-HNI-0042',
        customerName: 'Ngân hàng Vietcombank - CN Hoàn Kiếm',
        address: 'Số 12 phố Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
        createdDate: DateTime.now().subtract(const Duration(hours: 2)),
        slaDueDate: DateTime.now().add(const Duration(hours: 2)),
        assignedToName: 'Trần Văn Kỹ Thuật',
        errorName: 'Kẹt tiền khay cuốn (CDM Cash Out Dispenser)',
      ),
      TicketModel(
        ticketId: 'TK_002',
        ticketNo: 'TKT-2026-0879',
        title: 'Màn hình cảm ứng bị lệch cảm ứng',
        content: 'Màn hình cảm ứng 15-inch chạm góc phải không ăn, cần hiệu chỉnh hoặc thay thế panel cảm ứng.',
        status: 'Chờ xử lý',
        priority: 'Bình thường',
        atmId: 'ATM_102',
        atmCode: 'BIDV-DDA-0115',
        customerName: 'Ngân hàng BIDV - CN Đống Đa',
        address: 'Số 71 Nguyễn Chí Thanh, Đống Đa, Hà Nội',
        createdDate: DateTime.now().subtract(const Duration(hours: 5)),
        slaDueDate: DateTime.now().add(const Duration(hours: 6)),
        assignedToName: 'Trần Văn Kỹ Thuật',
        errorName: 'Hỏng màn hình cảm ứng (Touch Panel)',
      ),
      TicketModel(
        ticketId: 'TK_003',
        ticketNo: 'TKT-2026-0865',
        title: 'Mất kết nối mạng VPN và camera giám sát',
        content: 'Modem 4G/Router mất tín hiệu kết nối về trung tâm chuyển mạch từ 06:00 sáng.',
        status: 'Hoàn thành',
        priority: 'Cao',
        atmId: 'ATM_103',
        atmCode: 'TCB-CGY-0098',
        customerName: 'Ngân hàng Techcombank - CN Cầu Giấy',
        address: 'Tòa nhà Duy Tân, Cầu Giấy, Hà Nội',
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
        slaDueDate: DateTime.now().subtract(const Duration(hours: 18)),
        assignedToName: 'Trần Văn Kỹ Thuật',
        rating: 5,
        feedbackNote: 'Xử lý nhanh chóng, thay cáp mạng và reset bộ phát hoạt động tốt.',
      ),
    ];
  }

  List<TicketModel> _getMockTeamTickets() {
    return [
      TicketModel(
        ticketId: 'TK_004',
        ticketNo: 'TKT-2026-0890',
        title: 'Bảo dưỡng định kỳ quý 3/2026',
        content: 'Vệ sinh đầu đọc thẻ, kiểm tra két bảo mật và bôi trơn hệ thống bánh răng cơ học.',
        status: 'Chờ phân công',
        priority: 'Bình thường',
        atmId: 'ATM_104',
        atmCode: 'MBB-TXN-0056',
        customerName: 'Ngân hàng MBBank - CN Thanh Xuân',
        address: 'Nguyễn Trãi, Thanh Xuân, Hà Nội',
        createdDate: DateTime.now().subtract(const Duration(minutes: 30)),
        slaDueDate: DateTime.now().add(const Duration(hours: 24)),
      ),
      TicketModel(
        ticketId: 'TK_005',
        ticketNo: 'TKT-2026-0892',
        title: 'Đầu đọc thẻ nuốt thẻ khách hàng liên tục',
        content: 'Motor cuốn thẻ bị mòn trục cao su, cần thay module Card Reader Motor.',
        status: 'Chờ phân công',
        priority: 'Khẩn cấp',
        atmId: 'ATM_105',
        atmCode: 'VPB-HKM-0021',
        customerName: 'Ngân hàng VPBank - CN Hai Bà Trưng',
        address: 'Bà Triệu, Hai Bà Trưng, Hà Nội',
        createdDate: DateTime.now().subtract(const Duration(minutes: 10)),
        slaDueDate: DateTime.now().add(const Duration(hours: 3)),
      ),
    ];
  }
}
