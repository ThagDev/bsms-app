import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/part_model.dart';

class PartRepository {
  final ApiClient _apiClient;

  PartRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Danh mục Linh kiện: F_PART (48)
  Future<List<PartModel>> getParts({String? query}) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fPart,
        params: {ApiParamKeys.data: query},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => PartModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _getMockParts(query: query);
  }

  /// Tạo yêu cầu cấp linh kiện/thiết bị cho Ticket: F_ADD_REQUEST_DEVICE (50)
  Future<bool> requestPart({
    required String ticketId,
    required String partId,
    required int quantity,
    String? note,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fAddRequestDevice,
        params: {
          ApiParamKeys.ticketId: ticketId,
          ApiParamKeys.partId: partId,
          ApiParamKeys.data: quantity,
          ApiParamKeys.note: note,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true;
    }
  }

  /// Danh sách yêu cầu thiết bị theo Ticket: F_DEVICEREQUESTBYTICKETID (49)
  Future<List<DeviceRequestModel>> getRequestsByTicket(String ticketId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fDeviceRequestByTicketId,
        params: {ApiParamKeys.ticketId: ticketId},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => DeviceRequestModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return [
      DeviceRequestModel(
        requestId: 'REQ_01',
        ticketId: ticketId,
        partId: 'PART_01',
        partName: 'Mô-tơ cuốn tiền Diebold Opteva (Cash Feed Motor)',
        quantity: 1,
        status: 'Đã duyệt',
        note: 'Cần thay thế gấp tại hiện trường',
      ),
    ];
  }

  List<PartModel> _getMockParts({String? query}) {
    final list = [
      const PartModel(
        partId: 'PART_01',
        partCode: 'LK-MOT-001',
        partName: 'Mô-tơ cuốn tiền Diebold Opteva (Cash Feed Motor)',
        quantity: 14,
        unit: 'Bộ',
        description: 'Module dẫn hướng tiền vào khay',
      ),
      const PartModel(
        partId: 'PART_02',
        partCode: 'LK-SCR-002',
        partName: 'Màn hình cảm ứng LCD 15-inch NCR',
        quantity: 6,
        unit: 'Cái',
        description: 'Panel cảm ứng hồng ngoại công nghiệp',
      ),
      const PartModel(
        partId: 'PART_03',
        partCode: 'LK-RDR-003',
        partName: 'Đầu đọc thẻ Motorized Card Reader Hyosung',
        quantity: 9,
        unit: 'Cái',
        description: 'Đầu đọc thẻ từ & chip chuẩn EMV',
      ),
      const PartModel(
        partId: 'PART_04',
        partCode: 'LK-PRN-004',
        partName: 'Đầu in nhiệt hóa đơn biên lai (Thermal Receipt Printer)',
        quantity: 25,
        unit: 'Cái',
        description: 'Khổ giấy 80mm có dao cắt tự động',
      ),
    ];

    if (query == null || query.isEmpty) return list;
    return list.where((p) =>
      p.partCode.toLowerCase().contains(query.toLowerCase()) ||
      p.partName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
