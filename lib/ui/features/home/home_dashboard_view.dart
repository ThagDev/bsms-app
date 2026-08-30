import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../auth/auth_view_model.dart';
import 'home_view_model.dart';
import '../shared_widgets/metric_card.dart';
import '../shared_widgets/status_badge.dart';
import '../tickets/ticket_detail_view.dart';
import '../tickets/ticket_list_view.dart';
import '../atm/atm_list_view.dart';
import '../parts/part_list_view.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BẢNG ĐIỀU HÀNH KỸ THUẬT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới dữ liệu',
            onPressed: () => homeVM.loadDashboardData(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => homeVM.loadDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryNavy, AppTheme.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryNavy.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Kỹ sư dịch vụ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentCyan.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  user?.role ?? 'Kỹ thuật viên',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.fiber_manual_record, color: Colors.greenAccent, size: 10),
                              const SizedBox(width: 4),
                              const Text('GPS Online', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Metrics Grid
              const Text('Chỉ số vận hành', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  MetricCard(
                    title: 'Ticket đang xử lý',
                    value: homeVM.inProgressTicketsCount.toString(),
                    icon: Icons.pending_actions,
                    color: AppTheme.statusInProgress,
                  ),
                  MetricCard(
                    title: 'Cảnh báo SLA',
                    value: homeVM.overdueSlaCount.toString(),
                    icon: Icons.timer_outlined,
                    color: AppTheme.statusUrgent,
                  ),
                  MetricCard(
                    title: 'ATM báo lỗi',
                    value: homeVM.errorAtmCount.toString(),
                    icon: Icons.atm,
                    color: AppTheme.statusPending,
                  ),
                  MetricCard(
                    title: 'Tổng Ticket trong ngày',
                    value: homeVM.totalTicketsCount.toString(),
                    icon: Icons.assignment_turned_in,
                    color: AppTheme.statusCompleted,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text('Tác vụ nhanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickActionButton(
                    icon: Icons.search,
                    label: 'Tra cứu',
                    color: Colors.blue.shade700,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketListView())),
                  ),
                  _QuickActionButton(
                    icon: Icons.atm,
                    label: 'Trạm ATM',
                    color: Colors.teal.shade700,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AtmListView())),
                  ),
                  _QuickActionButton(
                    icon: Icons.build_outlined,
                    label: 'Linh kiện',
                    color: Colors.indigo.shade700,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartListView())),
                  ),
                  _QuickActionButton(
                    icon: Icons.my_location,
                    label: 'Gửi GPS',
                    color: Colors.orange.shade800,
                    onTap: () {
                      authVM.updateGpsLocation(21.0285, 105.8542);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã cập nhật toạ độ GPS lên máy chủ (F_UPDATELOCATION)')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Urgent Tasks / Pending Tickets List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sự cố cần xử lý gấp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketListView())),
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (homeVM.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (homeVM.pendingTickets.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('Không có sự cố nào đang chờ xử lý 🎉')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeVM.pendingTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = homeVM.pendingTickets[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Formatters.getTicketStatusColor(ticket.status).withOpacity(0.15),
                          child: Icon(
                            Icons.error_outline,
                            color: Formatters.getTicketStatusColor(ticket.status),
                          ),
                        ),
                        title: Text(
                          ticket.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${ticket.atmCode ?? ''} • ${ticket.customerName ?? ''}', style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                StatusBadge(text: ticket.status),
                                const SizedBox(width: 8),
                                if (ticket.isSlaOverdue)
                                  const StatusBadge(text: 'Quá hạn SLA', color: AppTheme.statusUrgent),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TicketDetailView(ticket: ticket)),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
