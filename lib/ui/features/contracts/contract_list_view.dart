import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import 'contract_view_model.dart';
import 'contract_detail_view.dart';
import '../../shared_widgets/status_badge.dart';

class ContractListView extends StatefulWidget {
  const ContractListView({super.key});

  @override
  State<ContractListView> createState() => _ContractListViewState();
}

class _ContractListViewState extends State<ContractListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractViewModel>().loadContracts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractVM = context.watch<ContractViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('HỢP ĐỒNG & DỊCH VỤ (F_17)')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (q) => context.read<ContractViewModel>().loadContracts(query: q),
              decoration: const InputDecoration(
                hintText: 'Tìm theo số hợp đồng, tên khách hàng...',
                prefixIcon: Icon(Icons.search, size: 20),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: contractVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: contractVM.contracts.length,
                    itemBuilder: (context, index) {
                      final c = contractVM.contracts[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNavy.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.description_outlined, color: AppTheme.primaryNavy, size: 26),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(c.contractNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              StatusBadge(text: c.status),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(c.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1),
                              const SizedBox(height: 4),
                              Text('${c.customerName} • ${c.totalAtmCount} máy ATM', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                              const SizedBox(height: 4),
                              Text('Thời hạn: ${Formatters.formatDate(c.startDate)} - ${Formatters.formatDate(c.endDate)}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ContractDetailView(contract: c)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
