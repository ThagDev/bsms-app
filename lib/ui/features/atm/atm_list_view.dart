import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'atm_view_model.dart';
import 'atm_detail_view.dart';
import '../shared_widgets/status_badge.dart';
import '../shared_widgets/empty_state.dart';

class AtmListView extends StatefulWidget {
  const AtmListView({super.key});

  @override
  State<AtmListView> createState() => _AtmListViewState();
}

class _AtmListViewState extends State<AtmListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AtmViewModel>().loadAtms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final atmVM = context.watch<AtmViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DANH SÁCH TRẠM ATM (F_09)'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (q) => context.read<AtmViewModel>().loadAtms(query: q),
              decoration: InputDecoration(
                hintText: 'Tìm theo mã trạm, số serial, địa chỉ...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<AtmViewModel>().loadAtms();
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: atmVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : atmVM.atms.isEmpty
                    ? EmptyState(
                        title: 'Không tìm thấy trạm ATM',
                        onRetry: () => context.read<AtmViewModel>().loadAtms(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => context.read<AtmViewModel>().loadAtms(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: atmVM.atms.length,
                          itemBuilder: (context, index) {
                            final atm = atmVM.atms[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryNavy.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.atm, color: AppTheme.primaryNavy, size: 26),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(atm.atmCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    StatusBadge(text: atm.status, isAtm: true),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('${atm.customerName ?? ''} • Model: ${atm.model ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            atm.address ?? '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => AtmDetailView(atm: atm)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
