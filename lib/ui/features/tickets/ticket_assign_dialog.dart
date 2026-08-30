import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/ticket_model.dart';
import 'ticket_view_model.dart';

class TicketAssignDialog extends StatefulWidget {
  final TicketModel ticket;

  const TicketAssignDialog({super.key, required this.ticket});

  @override
  State<TicketAssignDialog> createState() => _TicketAssignDialogState();
}

class _TicketAssignDialogState extends State<TicketAssignDialog> {
  String _selectedTechId = 'TECH_01';
  String _selectedTechName = 'Trần Văn Kỹ Thuật (Hà Nội)';
  bool _isSubmitting = false;

  final List<Map<String, String>> _engineers = [
    {'id': 'TECH_01', 'name': 'Trần Văn Kỹ Thuật (Hà Nội)'},
    {'id': 'TECH_02', 'name': 'Lê Văn Kỹ Sư (Hoàn Kiếm)'},
    {'id': 'TECH_03', 'name': 'Phạm Đức Máy (Cầu Giấy)'},
    {'id': 'TECH_04', 'name': 'Hoàng Minh ATM (Đống Đa)'},
  ];

  void _submit() async {
    setState(() => _isSubmitting = true);
    final vm = context.read<TicketViewModel>();
    final success = await vm.assignTicket(
      ticketId: widget.ticket.ticketId,
      assignToUserId: _selectedTechId,
      assignToName: _selectedTechName,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã phân công sự cố cho $_selectedTechName (F_ASSIGNTICKET)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.person_add_alt_1),
          SizedBox(width: 8),
          Text('Phân công Kỹ sư (F_47)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Mã sự cố: ${widget.ticket.ticketNo}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedTechId,
            decoration: const InputDecoration(labelText: 'Chọn Kỹ thuật viên tiếp nhận'),
            items: _engineers.map((eng) {
              return DropdownMenuItem(value: eng['id'], child: Text(eng['name']!, style: const TextStyle(fontSize: 13)));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedTechId = val;
                  _selectedTechName = _engineers.firstWhere((e) => e['id'] == val)['name']!;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Xác nhận phân công'),
        ),
      ],
    );
  }
}
