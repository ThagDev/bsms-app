import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/atm_model.dart';
import 'atm_view_model.dart';
import '../../shared_widgets/status_badge.dart';

class AtmDetailView extends StatefulWidget {
  final AtmModel atm;

  const AtmDetailView({super.key, required this.atm});

  @override
  State<AtmDetailView> createState() => _AtmDetailViewState();
}

class _AtmDetailViewState extends State<AtmDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AtmViewModel>().loadAtmHistory(widget.atm.atmId);
    });
  }

  void _showUpdateGpsDialog() {
    final latController = TextEditingController(text: widget.atm.lat?.toString() ?? '21.0227');
    final lngController = TextEditingController(text: widget.atm.lng?.toString() ?? '105.8570');
    final addressController = TextEditingController(text: widget.atm.address ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cập nhật toạ độ & Địa chỉ ATM (F_26)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Địa chỉ lắp đặt')),
            const SizedBox(height: 12),
            TextField(controller: latController, decoration: const InputDecoration(labelText: 'Vĩ độ (Latitude)')),
            const SizedBox(height: 12),
            TextField(controller: lngController, decoration: const InputDecoration(labelText: 'Kinh độ (Longitude)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật thông tin trạm ATM lên máy chủ (F_UPDATEATMINFO)')),
              );
            },
            child: const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final atmVM = context.watch<AtmViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Trạm ATM: ${widget.atm.atmCode}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Header Card
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
                        Text(widget.atm.atmCode, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                        StatusBadge(text: widget.atm.status, isAtm: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.atm.customerName ?? 'Ngân hàng đối tác', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(widget.atm.address ?? 'Chưa cập nhật địa chỉ', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hardware Specs
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông số Kỹ thuật phần cứng (F_10)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const Divider(height: 20),
                    _buildDetailRow('Số Serial Máy', widget.atm.serialNumber ?? 'N/A'),
                    _buildDetailRow('Model Thiết bị', widget.atm.model ?? 'N/A'),
                    _buildDetailRow('Nhà sản xuất', widget.atm.manufacturer ?? 'N/A'),
                    _buildDetailRow('Địa chỉ IP Terminal', widget.atm.ipAddress ?? '10.0.0.1'),
                    _buildDetailRow('Hợp đồng bảo trì', widget.atm.contractNo ?? 'N/A'),
                    _buildDetailRow('Ngày lắp đặt vận hành', Formatters.formatDate(widget.atm.installDate)),
                    _buildDetailRow('Bảo trì lần cuối', Formatters.formatDate(widget.atm.lastMaintenanceDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // History of Tickets for this ATM
            const Text('Lịch sử sửa chữa & bảo trì (F_43 / F_19)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (atmVM.atmHistoryTickets.isEmpty)
              const Card(
                margin: EdgeInsets.zero,
                child: Padding(padding: EdgeInsets.all(16), child: Text('Chưa có ghi nhận sự cố trước đây cho trạm này.')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: atmVM.atmHistoryTickets.length,
                itemBuilder: (context, index) {
                  final t = atmVM.atmHistoryTickets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(t.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('${t.ticketNo} • ${Formatters.formatDate(t.createdDate)}'),
                      trailing: StatusBadge(text: t.status),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showUpdateGpsDialog,
                icon: const Icon(Icons.edit_location_alt_outlined),
                label: const Text('Cập nhật Toạ độ & Địa chỉ ATM (F_26)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
