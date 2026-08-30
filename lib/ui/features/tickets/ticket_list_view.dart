import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../auth/auth_view_model.dart';
import 'ticket_view_model.dart';
import 'ticket_detail_view.dart';
import '../../shared_widgets/status_badge.dart';
import '../../shared_widgets/empty_state.dart';

import '../navigation/main_navigation_scaffold.dart';

class TicketListView extends StatefulWidget {
  const TicketListView({super.key});

  @override
  State<TicketListView> createState() => _TicketListViewState();
}

class _TicketListViewState extends State<TicketListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketViewModel>().loadTickets(isTeam: false);
      context.read<TicketViewModel>().loadTickets(isTeam: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final isTeam = _tabController.index == 1;
    context.read<TicketViewModel>().search(
      query,
      status: _selectedStatusFilter,
      isTeam: isTeam,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketVM = context.watch<TicketViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final isLeader = authVM.currentUser?.isLeader ?? false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Mở danh mục',
          onPressed: () => MainNavigationScaffold.of(context)?.openDrawer() ?? Scaffold.of(context).openDrawer(),
        ),
        title: const Text(
          'QUẢN LÝ SỰ CỐ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentCyan,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: 'Cá nhân'),
            Tab(text: isLeader ? 'Phân công đội' : 'Toàn đội'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Box
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm mã Ticket, tên ATM, lỗi...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Tất cả', null),
                      _buildFilterChip('Chờ xử lý', 'Chờ xử lý'),
                      _buildFilterChip('Đang xử lý', 'Đang xử lý'),
                      _buildFilterChip('Hoàn thành', 'Hoàn thành'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTicketList(ticketVM.myTickets, ticketVM.isLoading, isTeam: false),
                _buildTicketList(ticketVM.teamTickets, ticketVM.isLoading, isTeam: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? statusValue) {
    final isSelected = _selectedStatusFilter == statusValue;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        selectedColor: AppTheme.primaryNavy,
        backgroundColor: Colors.grey.shade100,
        showCheckmark: false,
        onSelected: (selected) {
          setState(() {
            _selectedStatusFilter = selected ? statusValue : null;
          });
          _onSearchChanged(_searchController.text);
        },
      ),
    );
  }

  Widget _buildTicketList(List tickets, bool isLoading, {required bool isTeam}) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tickets.isEmpty) {
      return EmptyState(
        title: 'Không tìm thấy sự cố nào',
        subtitle: 'Thử thay đổi từ khóa tìm kiếm hoặc làm mới lại dữ liệu',
        onRetry: () => context.read<TicketViewModel>().loadTickets(isTeam: isTeam),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TicketViewModel>().loadTickets(isTeam: isTeam),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TicketDetailView(ticket: ticket)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNavy.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ticket.ticketNo,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryNavy,
                            ),
                          ),
                        ),
                        StatusBadge(text: ticket.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.atm, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(ticket.atmCode ?? 'N/A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        const Text('•', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ticket.customerName ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: ticket.isSlaOverdue ? Colors.red : Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatDateTime(ticket.createdDate),
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        if (ticket.assignedToName != null)
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                ticket.assignedToName!,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
