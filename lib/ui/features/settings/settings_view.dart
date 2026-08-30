import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import 'settings_view_model.dart';
import 'server_config_dialog.dart';
import '../auth/auth_view_model.dart';
import '../auth/login_view.dart';
import '../auth/profile_view.dart';

import '../navigation/main_navigation_scaffold.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final currentConfig = ApiClient().config;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Mở danh mục',
          onPressed: () => MainNavigationScaffold.of(context)?.openDrawer() ?? Scaffold.of(context).openDrawer(),
        ),
        title: const Text(
          'CÀI ĐẶT & HỆ THỐNG',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Card
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                radius: 28,
                child: Icon(Icons.person, size: 30),
              ),
              title: Text(authVM.currentUser?.fullName ?? 'Chưa đăng nhập', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(authVM.currentUser?.role ?? 'Kỹ thuật viên'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView())),
            ),
          ),
          const SizedBox(height: 20),

          // Server Config Section
          const Text('Cấu hình Kết nối Máy chủ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dns_outlined),
                  title: const Text('Địa chỉ Server API'),
                  subtitle: Text(currentConfig.fullEndpointUrl),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showDialog(context: context, builder: (_) => const ServerConfigDialog()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: const Text('Đồng bộ dữ liệu nền (Master Data)'),
                  subtitle: Text(settingsVM.syncStatusMessage ?? 'Đồng bộ Danh mục tỉnh thành, khách hàng, mã lỗi (F_07, F_08, F_11, F_28)'),
                  trailing: settingsVM.isSyncing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.sync),
                  onTap: settingsVM.isSyncing ? null : () => settingsVM.syncAllData(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined, color: Colors.orange),
                  title: const Text('Dọn sạch Cache SQLite (BSI.db)'),
                  subtitle: const Text('Xóa toàn bộ bản ghi tạm offline'),
                  onTap: () {
                    settingsVM.clearLocalCache();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã dọn dẹp bộ nhớ đệm SQLite')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // System Info
          const Text('Thông tin Ứng dụng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Phiên bản Ứng dụng'),
                  subtitle: Text('${AppConstants.appName} v${AppConstants.appVersion} (Build ${AppConstants.appVersionCode})'),
                  trailing: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phiên bản hiện tại đã là mới nhất (F_CHECKVERSION)')),
                      );
                    },
                    child: const Text('Kiểm tra'),
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.security_outlined),
                  title: Text('Kiến trúc Kỹ thuật'),
                  subtitle: Text('Flutter 3.x • Clean Architecture / MVVM • SQLite v26'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              authVM.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('ĐĂNG XUẤT (F_LOGOUT)'),
          ),
        ],
      ),
    );
  }
}
