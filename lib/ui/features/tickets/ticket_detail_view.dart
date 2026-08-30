import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/ticket_model.dart';
import '../auth/auth_view_model.dart';
import 'ticket_view_model.dart';
import 'ticket_update_dialog.dart';
import 'ticket_assign_dialog.dart';
import '../../shared_widgets/status_badge.dart';
import '../parts/part_request_dialog.dart';

class TicketDetailView extends StatefulWidget {
  final TicketModel ticket;

  const TicketDetailView({super.key, required this.ticket});

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  late TicketModel _currentTicket;

  @override
  void initState() {
    super.initState();
    _currentTicket = widget.ticket;
  }

  void _openUpdateDialog() async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => TicketUpdateDialog(ticket: _currentTicket),
    );
    if (updated == true && mounted) {
      final ticketVM = context.read<TicketViewModel>();
      final fresh = ticketVM.myTickets.firstWhere(
        (t) => t.ticketId == _currentTicket.ticketId,
        orElse: () => _currentTicket,
      );
      setState(() => _currentTicket = fresh);
    }
  }

  void _openAssignDialog() async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => TicketAssignDialog(ticket: _currentTicket),
    );
    if (updated == true && mounted) {
      final ticketVM = context.read<TicketViewModel>();
      final fresh = ticketVM.teamTickets.firstWhere(
        (t) => t.ticketId == _currentTicket.ticketId,
        orElse: () => _currentTicket,
      );
      setState(() => _currentTicket = fresh);
    }
  }

  void _openPartRequestDialog() {
    showDialog(
      context: context,
      builder: (_) => PartRequestDialog(ticketId: _currentTicket.ticketId),
    );
  }

  void _showRatingDialog() {
    int selectedRating = 5;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Đánh giá & Nghiệm thu sự cố (F_38)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Mức độ hài lòng của khách hàng:'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => selectedRating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Ý kiến phản hồi từ ngân hàng'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
            ElevatedButton(
              onPressed: () {
                context.read<TicketViewModel>().submitRating(
                  ticketId: _currentTicket.ticketId,
                  rating: selectedRating,
                  feedback: feedbackController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gửi đánh giá thành công (F_RATING)')),
                );
              },
              child: const Text('Gửi đánh giá'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final isLeader = authVM.currentUser?.isLeader ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTicket.ticketNo),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sao chép liên kết sự cố')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Badges
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(text: _currentTicket.status),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            'Ưu tiên: ${_currentTicket.priority}',
                            style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentTicket.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentTicket.content,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SLA & Timeline Card
            Card(
              margin: EdgeInsets.zero,
              color: _currentTicket.isSlaOverdue ? Colors.red.shade50 : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      _currentTicket.isSlaOverdue ? Icons.warning_amber_rounded : Icons.timer_outlined,
                      color: _currentTicket.isSlaOverdue ? Colors.red.shade700 : AppTheme.primaryNavy,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentTicket.isSlaOverdue ? 'ĐÃ QUÁ HẠN CAM KẾT SLA' : 'THỜI HẠN XỬ LÝ (SLA CAM KẾT)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _currentTicket.isSlaOverdue ? Colors.red.shade900 : AppTheme.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Hạn chót: ${Formatters.formatDateTime(_currentTicket.slaDueDate)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _currentTicket.isSlaOverdue ? Colors.red.shade900 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Equipment & Location Info
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin thiết bị & Khách hàng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.account_balance, 'Khách hàng', _currentTicket.customerName ?? 'N/A'),
                    _buildInfoRow(Icons.atm, 'Mã trạm ATM', _currentTicket.atmCode ?? 'N/A'),
                    _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ hiện trường', _currentTicket.address ?? 'N/A'),
                    _buildInfoRow(Icons.build_circle_outlined, 'Phân loại lỗi', _currentTicket.errorName ?? 'Lỗi chung'),
                    _buildInfoRow(Icons.person, 'Kỹ sư phụ trách', _currentTicket.assignedToName ?? 'Chưa phân công'),
                    _buildInfoRow(Icons.calendar_today, 'Thời điểm tạo', Formatters.formatDateTime(_currentTicket.createdDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openUpdateDialog,
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Cập nhật tiến độ'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openPartRequestDialog,
                    icon: const Icon(Icons.inventory_2_outlined, size: 18),
                    label: const Text('Cấp linh kiện'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (isLeader)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openAssignDialog,
                  icon: const Icon(Icons.assignment_ind_outlined),
                  label: const Text('Phân công lại Kỹ sư tiếp nhận (F_47)'),
                ),
              ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _showRatingDialog,
                icon: const Icon(Icons.star_outline, color: Colors.amber),
                label: const Text('Nghiệm thu & Đánh giá khách hàng (F_38)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
