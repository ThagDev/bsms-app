import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import 'part_view_model.dart';
import 'part_request_dialog.dart';
import '../shared_widgets/empty_state.dart';

class PartListView extends StatefulWidget {
  const PartListView({super.key});

  @override
  State<PartListView> createState() => _PartListViewState();
}

class _PartListViewState extends State<PartListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartViewModel>().loadParts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partVM = context.watch<PartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('KHO LINH KIỆN & VẬT TƯ (F_48)')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (q) => context.read<PartViewModel>().loadParts(query: q),
              decoration: const InputDecoration(
                hintText: 'Tìm theo mã linh kiện, tên phụ tùng...',
                prefixIcon: Icon(Icons.search, size: 20),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: partVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : partVM.parts.isEmpty
                    ? EmptyState(
                        title: 'Không tìm thấy linh kiện',
                        onRetry: () => context.read<PartViewModel>().loadParts(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => context.read<PartViewModel>().loadParts(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: partVM.parts.length,
                          itemBuilder: (context, index) {
                            final part = partVM.parts[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryNavy.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.build_circle_outlined, color: AppTheme.primaryNavy, size: 26),
                                ),
                                title: Text(part.partName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('Mã: ${part.partCode} • ${part.description ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                    const SizedBox(height: 4),
                                    Text('Tồn kho: ${part.quantity} ${part.unit}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => PartRequestDialog(initialPartId: part.partId),
                                    );
                                  },
                                  child: const Text('Yêu cầu', style: TextStyle(fontSize: 12)),
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
