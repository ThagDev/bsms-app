import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../home/home_dashboard_view.dart';
import '../tickets/ticket_list_view.dart';
import '../atm/atm_list_view.dart';
import '../contracts/contract_list_view.dart';
import '../mail/mail_list_view.dart';
import '../mail/mail_view_model.dart';
import '../settings/settings_view.dart';

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

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

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryNavy),
            label: 'Tổng quan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number, color: AppTheme.primaryNavy),
            label: 'Sự cố (Ticket)',
          ),
          const NavigationDestination(
            icon: Icon(Icons.atm_outlined),
            selectedIcon: Icon(Icons.atm, color: AppTheme.primaryNavy),
            label: 'Trạm ATM',
          ),
          const NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description, color: AppTheme.primaryNavy),
            label: 'Hợp đồng',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: mailVM.unreadCount > 0,
              label: Text(mailVM.unreadCount.toString()),
              child: const Icon(Icons.mail_outline),
            ),
            selectedIcon: Badge(
              isLabelVisible: mailVM.unreadCount > 0,
              label: Text(mailVM.unreadCount.toString()),
              child: const Icon(Icons.mail, color: AppTheme.primaryNavy),
            ),
            label: 'Hòm thư',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryNavy),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
