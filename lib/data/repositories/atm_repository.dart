import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/atm_model.dart';
import '../models/ticket_model.dart';
import '../models/contract_model.dart';

class AtmRepository {
  final ApiClient _apiClient;

  AtmRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Lấy danh sách máy ATM: F_ATMLIST (9)
  Future<List<AtmModel>> getAtmList({
    String? query,
    String? province,
    String? customerId,
    int pageNo = 1,
  }) async {
    try {
      final response = await _apiClient.callFunction(
        ApiFunctionCodes.fAtmList,
        params: {
          ApiParamKeys.data: query,
          ApiParamKeys.pageNo: pageNo,
          if (province != null) ApiParamKeys.province: province,
          if (customerId != null) ApiParamKeys.customer: customerId,
        },
      );
      if (response.isSuccess && response.data is List) {
        return (response.data as List)
            .map((item) => AtmModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return _getMockAtms(query: query);
  }

  /// Chi tiết thông tin trạm ATM: F_ATMDETAIL (10)
  Future<AtmModel?> getAtmDetail(String atmId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fAtmDetail,
        params: {ApiParamKeys.atmId: atmId},
      );
      if (res.isSuccess && res.data is Map<String, dynamic>) {
        return AtmModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (_) {}

    final list = _getMockAtms();
    return list.firstWhere((a) => a.atmId == atmId, orElse: () => list.first);
  }

  /// Cập nhật thông tin trạm ATM: F_UPDATEATMINFO (26)
  Future<bool> updateAtmInfo(AtmModel atm) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fUpdateAtmInfo,
        params: {
          ApiParamKeys.atmId: atm.atmId,
          ApiParamKeys.serial: atm.serialNumber,
          ApiParamKeys.address: atm.address,
          ApiParamKeys.lat: atm.lat,
          ApiParamKeys.lng: atm.lng,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true;
    }
  }

  /// Lịch sử xử lý & ticket của máy ATM: F_ATMTICKETLIST (19) / F_TICKETLISTFROMATM (32)
  Future<List<TicketModel>> getTicketsForAtm(String atmId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fAtmTicketList,
        params: {ApiParamKeys.atmId: atmId},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => TicketModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return [
      TicketModel(
        ticketId: 'TK_HIST_1',
        ticketNo: 'TKT-2026-0612',
        title: 'Bảo trì thay đầu đọc thẻ từ',
        content: 'Hoàn tất thay thế bộ phận đọc thẻ, kiểm tra giao dịch test thành công.',
        status: 'Hoàn thành',
        createdDate: DateTime.now().subtract(const Duration(days: 45)),
        assignedToName: 'Trần Văn Kỹ Thuật',
      ),
    ];
  }

  List<AtmModel> _getMockAtms({String? query}) {
    final list = [
      AtmModel(
        atmId: 'ATM_101',
        atmCode: 'VCB-HNI-0042',
        serialNumber: 'SN-DIEBOLD-99824',
        model: 'Diebold Nixdorf Opteva 828',
        manufacturer: 'Diebold Nixdorf',
        address: 'Số 12 phố Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
        province: 'Hà Nội',
        customerName: 'Vietcombank',
        status: 'Có sự cố',
        lat: 21.0227,
        lng: 105.8570,
        installDate: DateTime(2022, 5, 10),
        lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 20)),
        contractNo: 'HD-VCB-2024-08',
        ipAddress: '10.20.14.88',
      ),
      AtmModel(
        atmId: 'ATM_102',
        atmCode: 'BIDV-DDA-0115',
        serialNumber: 'SN-HYOSUNG-77621',
        model: 'Hyosung Monimax 7600T',
        manufacturer: 'Nautilus Hyosung',
        address: 'Số 71 Nguyễn Chí Thanh, Đống Đa, Hà Nội',
        province: 'Hà Nội',
        customerName: 'BIDV',
        status: 'Chờ xử lý',
        lat: 21.0205,
        lng: 105.8080,
        installDate: DateTime(2021, 11, 15),
        lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 12)),
        contractNo: 'HD-BIDV-2025-01',
        ipAddress: '10.30.22.105',
      ),
      AtmModel(
        atmId: 'ATM_103',
        atmCode: 'TCB-CGY-0098',
        serialNumber: 'SN-NCR-66832',
        model: 'NCR SelfServ 84 Walk-Up',
        manufacturer: 'NCR Corporation',
        address: 'Tòa nhà Duy Tân, Cầu Giấy, Hà Nội',
        province: 'Hà Nội',
        customerName: 'Techcombank',
        status: 'Hoạt động',
        lat: 21.0315,
        lng: 105.7830,
        installDate: DateTime(2023, 1, 20),
        lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 3)),
        contractNo: 'HD-TCB-2024-12',
        ipAddress: '10.45.10.98',
      ),
      AtmModel(
        atmId: 'ATM_104',
        atmCode: 'MBB-TXN-0056',
        serialNumber: 'SN-Wincor-55410',
        model: 'Wincor Nixdorf ProCash 2100xe',
        manufacturer: 'Wincor Nixdorf',
        address: 'Nguyễn Trãi, Thanh Xuân, Hà Nội',
        province: 'Hà Nội',
        customerName: 'MBBank',
        status: 'Hoạt động',
        lat: 20.9980,
        lng: 105.8120,
        installDate: DateTime(2020, 8, 5),
        lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 60)),
        contractNo: 'HD-MBB-2023-04',
        ipAddress: '10.50.8.56',
      ),
    ];

    if (query == null || query.isEmpty) return list;
    return list.where((a) =>
      a.atmCode.toLowerCase().contains(query.toLowerCase()) ||
      (a.serialNumber?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      (a.address?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      (a.customerName?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }
}
