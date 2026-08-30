import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/server_config_model.dart';
import '../../../core/constants/app_constants.dart';

class ServerConfigDialog extends StatefulWidget {
  const ServerConfigDialog({super.key});

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late TextEditingController _ipController;
  late TextEditingController _portController;
  late TextEditingController _endpointController;
  bool _useHttps = false;
  bool _isTesting = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    final config = ApiClient().config;
    _ipController = TextEditingController(text: config.ip);
    _portController = TextEditingController(text: config.port.toString());
    _endpointController = TextEditingController(text: config.customEndpoint);
    _useHttps = config.useHttps;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  void _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final testConfig = ServerConfig(
      ip: _ipController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 8082,
      useHttps: _useHttps,
      customEndpoint: _endpointController.text.trim(),
    );

    ApiClient().updateConfig(testConfig);
    final isOk = await ApiClient().pingServer();

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testResult = isOk
            ? 'Kết nối máy chủ thành công (200 OK)!'
            : 'Không thể kết nối đến máy chủ. Đang bật chế độ Offline / Mock Data.';
      });
    }
  }

  void _saveConfig() {
    final newConfig = ServerConfig(
      ip: _ipController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 8082,
      useHttps: _useHttps,
      customEndpoint: _endpointController.text.trim(),
    );
    ApiClient().updateConfig(newConfig);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật cấu hình máy chủ')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.dns_outlined),
          SizedBox(width: 8),
          Text('Cấu hình Server Backend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ IP / Domain',
                hintText: '115.78.3.210',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cổng (Port)',
                hintText: '8082',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'Đường dẫn Endpoint API',
                hintText: '/MobiFunc/Mobi.aspx',
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sử dụng kết nối bảo mật HTTPS', style: TextStyle(fontSize: 14)),
              value: _useHttps,
              onChanged: (val) => setState(() => _useHttps = val),
            ),
            const SizedBox(height: 12),
            if (_testResult != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _testResult!.contains('thành công') ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _testResult!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _testResult!.contains('thành công') ? Colors.green.shade900 : Colors.orange.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: _isTesting ? null : _testConnection,
              icon: _isTesting
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.network_check, size: 16),
              label: const Text('Kiểm tra kết nối (Ping F_39)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _saveConfig,
          child: const Text('Lưu cấu hình'),
        ),
      ],
    );
  }
}
