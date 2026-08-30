import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/contract_model.dart';
import 'contract_view_model.dart';
import '../shared_widgets/status_badge.dart';

class ContractDetailView extends StatefulWidget {
  final ContractModel contract;

  const ContractDetailView({super.key, required this.contract});

  @override
  State<ContractDetailView> createState() => _ContractDetailViewState();
}

class _ContractDetailViewState extends State<ContractDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractViewModel>().loadContractAtms(widget.contract.contractId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractVM = context.watch<ContractViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Hợp đồng: ${widget.contract.contractNo}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Text(widget.contract.contractNo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                        StatusBadge(text: widget.contract.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.contract.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(widget.contract.description ?? '', style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết phạm vi dịch vụ (F_16 / F_22)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const Divider(height: 20),
                    _buildRow('Khách hàng', widget.contract.customerName),
                    _buildRow('Khu vực dịch vụ', widget.contract.serviceRegion ?? 'Toàn quốc'),
                    _buildRow('Số lượng ATM quản lý', '${widget.contract.totalAtmCount} trạm'),
                    _buildRow('Ngày bắt đầu', Formatters.formatDate(widget.contract.startDate)),
                    _buildRow('Ngày kết thúc', Formatters.formatDate(widget.contract.endDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Danh sách trạm ATM trong hợp đồng (F_23)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (contractVM.contractAtms.isEmpty)
              const Card(
                margin: EdgeInsets.zero,
                child: Padding(padding: EdgeInsets.all(16), child: Text('Đang tải danh sách ATM thuộc hợp đồng...')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contractVM.contractAtms.length,
                itemBuilder: (context, index) {
                  final atm = contractVM.contractAtms[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.atm, color: AppTheme.primaryNavy),
                      title: Text(atm.atmCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(atm.address ?? ''),
                      trailing: StatusBadge(text: atm.status, isAtm: true),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
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
