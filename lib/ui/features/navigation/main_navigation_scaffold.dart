import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../auth/auth_view_model.dart';
import '../home/home_dashboard_view.dart';
import '../tickets/ticket_list_view.dart';
import '../atm/atm_list_view.dart';
import '../contracts/contract_list_view.dart';
import '../mail/mail_list_view.dart';
import '../mail/mail_view_model.dart';
import '../parts/part_list_view.dart';
import '../settings/settings_view.dart';

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  static _MainNavigationScaffoldState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainNavigationScaffoldState>();

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void navigateTo(int index) {
    setState(() => _currentIndex = index);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  final List<Widget> _views = const [
    HomeDashboardView(),
    TicketListView(),
    AtmListView(),
    ContractListView(),
    MailListView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final mailVM = context.watch<MailViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryNavy, AppTheme.primaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'B',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryNavy,
                  ),
                ),
              ),
              accountName: Text(
                user?.fullName ?? 'Kỹ thuật viên BSMS',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              accountEmail: Text(
                user?.userName != null ? 'Mã NV: ${user!.userName}' : 'Hệ thống Quản lý Dịch vụ Ngân hàng',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Tổng quan hệ thống', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    selected: _currentIndex == 0,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Quản lý Sự cố (Ticket)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    selected: _currentIndex == 1,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.atm_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Danh sách Trạm ATM', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    selected: _currentIndex == 2,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(2),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Hợp đồng & Dịch vụ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    selected: _currentIndex == 3,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(3),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail_outline, color: AppTheme.primaryNavy),
                    title: const Text('Hòm thư nội bộ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: mailVM.unreadCount > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.statusUrgent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              mailVM.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          )
                        : null,
                    selected: _currentIndex == 4,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(4),
                  ),
                  ListTile(
                    leading: const Icon(Icons.build_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Yêu cầu Linh kiện', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PartListView()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: AppTheme.primaryNavy),
                    title: const Text('Cài đặt & Máy chủ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    selected: _currentIndex == 5,
                    selectedTileColor: AppTheme.accentCyan.withOpacity(0.1),
                    onTap: () => navigateTo(5),
                  ),
                ],
              ),
            ),

            // Drawer Footer / Logout
            SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.statusUrgent),
                title: const Text('Đăng xuất tài khoản', style: TextStyle(color: AppTheme.statusUrgent, fontWeight: FontWeight.bold, fontSize: 14)),
                onTap: () => authVM.logout(),
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, size: 22),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryNavy, size: 22),
            label: 'Tổng quan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined, size: 22),
            selectedIcon: Icon(Icons.confirmation_number, color: AppTheme.primaryNavy, size: 22),
            label: 'Sự cố',
          ),
          const NavigationDestination(
            icon: Icon(Icons.atm_outlined, size: 22),
            selectedIcon: Icon(Icons.atm, color: AppTheme.primaryNavy, size: 22),
            label: 'ATM',
          ),
          const NavigationDestination(
            icon: Icon(Icons.description_outlined, size: 22),
            selectedIcon: Icon(Icons.description, color: AppTheme.primaryNavy, size: 22),
            label: 'Hợp đồng',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: mailVM.unreadCount > 0,
              label: Text(mailVM.unreadCount.toString()),
              child: const Icon(Icons.mail_outline, size: 22),
            ),
            selectedIcon: Badge(
              isLabelVisible: mailVM.unreadCount > 0,
              label: Text(mailVM.unreadCount.toString()),
              child: const Icon(Icons.mail, color: AppTheme.primaryNavy, size: 22),
            ),
            label: 'Thư',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined, size: 22),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryNavy, size: 22),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
