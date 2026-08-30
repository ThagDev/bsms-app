import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/ticket_model.dart';
import 'ticket_view_model.dart';

class TicketUpdateDialog extends StatefulWidget {
  final TicketModel ticket;

  const TicketUpdateDialog({super.key, required this.ticket});

  @override
  State<TicketUpdateDialog> createState() => _TicketUpdateDialogState();
}

class _TicketUpdateDialogState extends State<TicketUpdateDialog> {
  late String _selectedStatus;
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _statuses = [
    'Chờ xử lý',
    'Đang xử lý',
    'Chờ linh kiện',
    'Hoàn thành',
    'Hủy / Không xử lý được',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.ticket.status;
    if (!_statuses.contains(_selectedStatus)) {
      _selectedStatus = 'Đang xử lý';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    final vm = context.read<TicketViewModel>();
    final success = await vm.updateStatus(
      ticketId: widget.ticket.ticketId,
      newStatus: _selectedStatus,
      note: _noteController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật trạng thái sự cố (F_UPDATETICKET)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật tiến độ xử lý (F_05)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Trạng thái mới'),
              items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedStatus = val);
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Ghi chú / Phương án xử lý',
                hintText: 'Nhập chi tiết công việc đã thực hiện tại hiện trường...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Cập nhật'),
        ),
      ],
    );
  }
}
