import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'auth_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('HỒ SƠ KỸ THUẬT VIÊN (F_40)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppTheme.primaryNavy.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 52, color: AppTheme.primaryNavy),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(user?.fullName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user?.role ?? '', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            const SizedBox(height: 24),

            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow(Icons.badge_outlined, 'Mã nhân viên', user?.userId ?? 'N/A'),
                    const Divider(height: 16),
                    _buildRow(Icons.account_circle_outlined, 'Tên đăng nhập', user?.username ?? 'N/A'),
                    const Divider(height: 16),
                    _buildRow(Icons.email_outlined, 'Email liên hệ', user?.email ?? 'N/A'),
                    const Divider(height: 16),
                    _buildRow(Icons.phone_outlined, 'Số điện thoại', user?.phone ?? 'N/A'),
                    const Divider(height: 16),
                    _buildRow(Icons.business_outlined, 'Đơn vị / Phòng ban', user?.department ?? 'Trung tâm Kỹ thuật ATM'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryNavy),
        const SizedBox(width: 12),
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    );
  }
}
