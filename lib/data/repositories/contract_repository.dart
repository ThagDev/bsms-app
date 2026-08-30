import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/contract_model.dart';
import '../models/atm_model.dart';

class ContractRepository {
  final ApiClient _apiClient;

  ContractRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Tra cứu danh sách Hợp đồng: F_CONTRACTSEARCH (17)
  Future<List<ContractModel>> getContracts({String? query}) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fContractSearch,
        params: {ApiParamKeys.data: query},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => ContractModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _getMockContracts(query: query);
  }

  /// Chi tiết thông tin hợp đồng: F_CONTRACTINFOMATION (16)
  Future<ContractModel?> getContractDetail(String contractId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fContractInformation,
        params: {ApiParamKeys.contractId: contractId},
      );
      if (res.isSuccess && res.data is Map<String, dynamic>) {
        return ContractModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (_) {}

    final list = _getMockContracts();
    return list.firstWhere((c) => c.contractId == contractId, orElse: () => list.first);
  }

  /// Danh sách ATM thuộc hợp đồng: F_CONTRACTATMLIST (23)
  Future<List<AtmModel>> getAtmsByContract(String contractId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fContractAtmList,
        params: {ApiParamKeys.contractId: contractId},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => AtmModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return [
      AtmModel(
        atmId: 'ATM_101',
        atmCode: 'VCB-HNI-0042',
        address: 'Số 12 phố Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
        status: 'Có sự cố',
      ),
      AtmModel(
        atmId: 'ATM_106',
        atmCode: 'VCB-HNI-0043',
        address: 'Số 198 Trần Quang Khải, Hoàn Kiếm, Hà Nội',
        status: 'Hoạt động',
      ),
    ];
  }

  List<ContractModel> _getMockContracts({String? query}) {
    final list = [
      ContractModel(
        contractId: 'CTR_001',
        contractNo: 'HD-VCB-2024-08',
        title: 'Hợp đồng bảo dưỡng toàn diện hệ thống ATM VCB miền Bắc',
        customerName: 'Ngân hàng TMCP Ngoại Thương Việt Nam (Vietcombank)',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2026, 12, 31),
        status: 'Hiệu lực',
        totalAtmCount: 120,
        serviceRegion: 'Khu vực Hà Nội & các tỉnh phía Bắc',
        description: 'Bảo trì định kỳ 1 tháng/lần, SLA khắc phục sự cố cấp 1 trong vòng 2 giờ.',
      ),
      ContractModel(
        contractId: 'CTR_002',
        contractNo: 'HD-BIDV-2025-01',
        title: 'Hợp đồng dịch vụ ứng cứu sự cố ATM & CDM BIDV',
        customerName: 'Ngân hàng TMCP Đầu tư và Phát triển Việt Nam (BIDV)',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2027, 1, 1),
        status: 'Hiệu lực',
        totalAtmCount: 85,
        serviceRegion: 'Khu vực Hà Nội & Hải Phòng',
        description: 'Cung cấp linh kiện thay thế chính hãng và dịch vụ trực kỹ thuật 24/7.',
      ),
      ContractModel(
        contractId: 'CTR_003',
        contractNo: 'HD-TCB-2024-12',
        title: 'Hợp đồng nâng cấp phần cứng và phần mềm ATM',
        customerName: 'Ngân hàng TMCP Kỹ Thương Việt Nam (Techcombank)',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2025, 6, 1),
        status: 'Sắp hết hạn',
        totalAtmCount: 45,
        serviceRegion: 'Toàn quốc',
        description: 'Nâng cấp Windows 10 IoT và đầu đọc thẻ chip EMV/Contactless.',
      ),
    ];

    if (query == null || query.isEmpty) return list;
    return list.where((c) =>
      c.contractNo.toLowerCase().contains(query.toLowerCase()) ||
      c.title.toLowerCase().contains(query.toLowerCase()) ||
      c.customerName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
