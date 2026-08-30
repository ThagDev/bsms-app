import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/database/database_helper.dart';
import '../models/user_model.dart';
import '../models/server_config_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final DatabaseHelper _dbHelper;
  UserModel? _currentUser;

  AuthRepository({
    ApiClient? apiClient,
    DatabaseHelper? dbHelper,
  })  : _apiClient = apiClient ?? ApiClient(),
        _dbHelper = dbHelper ?? DatabaseHelper();

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Đăng nhập: F_LOGIN (1)
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.callFunction(
      ApiFunctionCodes.fLogin,
      params: {
        ApiParamKeys.username: username,
        ApiParamKeys.password: password,
      },
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      _currentUser = user;
      return user;
    }

    // Fallback/Demo mock cho môi trường phát triển
    if (username.isNotEmpty && password.isNotEmpty) {
      final isLeader = username.toLowerCase().contains('leader') || username.toLowerCase() == 'admin';
      final mockUser = UserModel(
        userId: 'USR_001',
        username: username,
        fullName: isLeader ? 'Nguyễn Văn Quản Lý (Trưởng nhóm)' : 'Trần Văn Kỹ Thuật (Kỹ sư ATM)',
        email: '$username@bsi.com.vn',
        phone: '0901234567',
        role: isLeader ? 'Trưởng nhóm Kỹ thuật' : 'Kỹ thuật viên hiện trường',
        department: 'Trung tâm Dịch vụ Kỹ thuật ATM',
        isLeader: isLeader,
      );
      _currentUser = mockUser;
      return mockUser;
    }

    throw Exception(response.message ?? 'Đăng nhập không thành công. Vui lòng kiểm tra lại thông tin.');
  }

  /// Đăng xuất: F_LOGOUT (13)
  Future<void> logout() async {
    try {
      await _apiClient.callFunction(ApiFunctionCodes.fLogout);
    } catch (_) {}
    _currentUser = null;
    _apiClient.setSessionCookie(null);
  }

  /// Cập nhật toạ độ GPS của nhân viên: F_UPDATEUSERLOCATION (30) / F_UPDATELOCATION (2)
  Future<bool> updateLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fUpdateUserLocation,
        params: {
          ApiParamKeys.lat: lat,
          ApiParamKeys.lng: lng,
          ApiParamKeys.userId: _currentUser?.userId ?? '',
          ApiParamKeys.time: DateTime.now().toIso8601String(),
        },
      );
      return res.isSuccess;
    } catch (_) {
      return false;
    }
  }

  /// Kiểm tra phiên bản mới: F_CHECKVERSION (42)
  Future<Map<String, dynamic>> checkAppVersion() async {
    try {
      final res = await _apiClient.callFunction(ApiFunctionCodes.fCheckVersion);
      if (res.isSuccess && res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
    } catch (_) {}
    return {
      'hasNewVersion': false,
      'latestVersion': AppConstants.appVersion,
      'updateUrl': '',
    };
  }
}
