import 'package:flutter/material.dart';
import '../../../data/repositories/master_data_repository.dart';
import '../../../core/database/database_helper.dart';

class SettingsViewModel extends ChangeNotifier {
  final MasterDataRepository _masterDataRepository;
  final DatabaseHelper _dbHelper;

  SettingsViewModel({
    MasterDataRepository? masterDataRepository,
    DatabaseHelper? dbHelper,
  })  : _masterDataRepository = masterDataRepository ?? MasterDataRepository(),
        _dbHelper = dbHelper ?? DatabaseHelper();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _syncStatusMessage;
  String? get syncStatusMessage => _syncStatusMessage;

  Future<void> syncAllData() async {
    _isSyncing = true;
    _syncStatusMessage = 'Đang đồng bộ danh mục Tỉnh thành, Khách hàng, Mã lỗi và Danh bạ...';
    notifyListeners();

    try {
      await _masterDataRepository.syncAll();
      _syncStatusMessage = 'Đồng bộ hoàn tất thành công vào SQLite cục bộ (BSI.db)!';
    } catch (e) {
      _syncStatusMessage = 'Đồng bộ thất bại: $e';
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> clearLocalCache() async {
    await _dbHelper.clearAllData();
    _syncStatusMessage = 'Đã dọn dẹp toàn bộ bộ nhớ đệm offline cục bộ.';
    notifyListeners();
  }
}
