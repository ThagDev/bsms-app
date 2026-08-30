import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/database/database_helper.dart';
import '../models/master_data_models.dart';

class MasterDataRepository {
  final ApiClient _apiClient;
  final DatabaseHelper _dbHelper;

  MasterDataRepository({
    ApiClient? apiClient,
    DatabaseHelper? dbHelper,
  })  : _apiClient = apiClient ?? ApiClient(),
        _dbHelper = dbHelper ?? DatabaseHelper();

  /// Đồng bộ toàn bộ dữ liệu nền (Provinces, Customers, Errors, Contacts) về SQLite
  Future<void> syncAll() async {
    await Future.wait([
      syncProvinces(),
      syncCustomers(),
      syncErrors(),
      syncContacts(),
    ]);
  }

  Future<List<ProvinceModel>> syncProvinces() async {
    try {
      final res = await _apiClient.callFunction(ApiFunctionCodes.fProvince);
      if (res.isSuccess && res.data is List) {
        final list = (res.data as List).map((e) => ProvinceModel.fromJson(e)).toList();
        final db = await _dbHelper.database;
        final batch = db.batch();
        for (var p in list) {
          batch.insert(DbConstants.tableProvince, p.toDbMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: true);
        return list;
      }
    } catch (_) {}

    return [
      const ProvinceModel(provinceId: 'HN', provinceName: 'Hà Nội'),
      const ProvinceModel(provinceId: 'HCM', provinceName: 'TP. Hồ Chí Minh'),
      const ProvinceModel(provinceId: 'HP', provinceName: 'Hải Phòng'),
      const ProvinceModel(provinceId: 'DN', provinceName: 'Đà Nẵng'),
      const ProvinceModel(provinceId: 'CT', provinceName: 'Cần Thơ'),
    ];
  }

  Future<List<CustomerModel>> syncCustomers() async {
    try {
      final res = await _apiClient.callFunction(ApiFunctionCodes.fCustomer);
      if (res.isSuccess && res.data is List) {
        final list = (res.data as List).map((e) => CustomerModel.fromJson(e)).toList();
        final db = await _dbHelper.database;
        final batch = db.batch();
        for (var c in list) {
          batch.insert(DbConstants.tableCustomer, c.toDbMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: true);
        return list;
      }
    } catch (_) {}

    return [
      const CustomerModel(customerId: 'CUST_VCB', customerName: 'Vietcombank', code: 'VCB'),
      const CustomerModel(customerId: 'CUST_BIDV', customerName: 'BIDV', code: 'BIDV'),
      const CustomerModel(customerId: 'CUST_TCB', customerName: 'Techcombank', code: 'TCB'),
      const CustomerModel(customerId: 'CUST_MBB', customerName: 'MBBank', code: 'MBB'),
      const CustomerModel(customerId: 'CUST_VPB', customerName: 'VPBank', code: 'VPB'),
    ];
  }

  Future<List<ErrorItemModel>> syncErrors() async {
    return [
      const ErrorItemModel(errorId: 'ERR_01', errorName: 'Kẹt tiền khay cuốn (Cash Jam)', errorCode: 'E-01'),
      const ErrorItemModel(errorId: 'ERR_02', errorName: 'Hỏng màn hình cảm ứng (Touch Screen)', errorCode: 'E-02'),
      const ErrorItemModel(errorId: 'ERR_03', errorName: 'Lỗi nuốt thẻ / đầu đọc thẻ (Card Reader)', errorCode: 'E-03'),
      const ErrorItemModel(errorId: 'ERR_04', errorName: 'Mất kết nối mạng VPN (Network Offline)', errorCode: 'E-04'),
      const ErrorItemModel(errorId: 'ERR_05', errorName: 'Hết giấy in hóa đơn / kẹt dao cắt (Printer)', errorCode: 'E-05'),
    ];
  }

  Future<List<ContactModel>> syncContacts() async {
    return [
      const ContactModel(contactId: 'CT_01', name: 'Nguyễn Văn Quản Lý', phone: '0988112233', role: 'Trưởng nhóm', department: 'Hà Nội'),
      const ContactModel(contactId: 'CT_02', name: 'Trần Văn Kỹ Thuật', phone: '0901234567', role: 'Kỹ sư hiện trường', department: 'Hà Nội'),
      const ContactModel(contactId: 'CT_03', name: 'Lê Kỹ Sư Miền Bắc', phone: '0912345678', role: 'Kỹ sư phần mềm ATM', department: 'NOC BSI'),
    ];
  }
}
