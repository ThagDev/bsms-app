import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'part_view_model.dart';

class PartRequestDialog extends StatefulWidget {
  final String? ticketId;
  final String? initialPartId;

  const PartRequestDialog({super.key, this.ticketId, this.initialPartId});

  @override
  State<PartRequestDialog> createState() => _PartRequestDialogState();
}

class _PartRequestDialogState extends State<PartRequestDialog> {
  late TextEditingController _ticketController;
  late TextEditingController _quantityController;
  final _noteController = TextEditingController();
  String _selectedPartId = 'PART_01';
  bool _isSubmitting = false;

  final List<Map<String, String>> _availableParts = [
    {'id': 'PART_01', 'name': 'Mô-tơ cuốn tiền Diebold Opteva'},
    {'id': 'PART_02', 'name': 'Màn hình cảm ứng LCD 15-inch NCR'},
    {'id': 'PART_03', 'name': 'Đầu đọc thẻ Motorized Card Reader'},
    {'id': 'PART_04', 'name': 'Đầu in nhiệt hóa đơn biên lai'},
  ];

  @override
  void initState() {
    super.initState();
    _ticketController = TextEditingController(text: widget.ticketId ?? 'TK_001');
    _quantityController = TextEditingController(text: '1');
    if (widget.initialPartId != null) {
      _selectedPartId = widget.initialPartId!;
    }
  }

  @override
  void dispose() {
    _ticketController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    final vm = context.read<PartViewModel>();
    final success = await vm.requestPart(
      ticketId: _ticketController.text.trim(),
      partId: _selectedPartId,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      note: _noteController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi yêu cầu cấp linh kiện (F_ADD_REQUEST_DEVICE)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yêu cầu cấp Linh kiện (F_50)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ticketController,
              decoration: const InputDecoration(labelText: 'Mã Ticket / Sự cố gắn kèm'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPartId,
              decoration: const InputDecoration(labelText: 'Linh kiện cần cấp'),
              items: _availableParts.map((p) {
                return DropdownMenuItem(value: p['id'], child: Text(p['name']!, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPartId = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số lượng'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Lý do / Hiện trạng hư hỏng'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Gửi yêu cầu'),
        ),
      ],
    );
  }
}
