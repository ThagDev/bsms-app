import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mail_view_model.dart';

class MailComposeView extends StatefulWidget {
  const MailComposeView({super.key});

  @override
  State<MailComposeView> createState() => _MailComposeViewState();
}

class _MailComposeViewState extends State<MailComposeView> {
  final _recipientController = TextEditingController(text: 'dispatch@bsi.com.vn');
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _recipientController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _send() async {
    if (_subjectController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ tiêu đề và nội dung thư')),
      );
      return;
    }

    setState(() => _isSending = true);
    final success = await context.read<MailViewModel>().sendEmail(
      recipient: _recipientController.text.trim(),
      subject: _subjectController.text.trim(),
      content: _contentController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi thư thành công (F_SENDEMAIL)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soạn thư mới (F_34)'),
        actions: [
          IconButton(
            icon: _isSending
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send),
            onPressed: _isSending ? null : _send,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(labelText: 'Người nhận (To)', prefixIcon: Icon(Icons.alternate_email)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Tiêu đề thư', prefixIcon: Icon(Icons.subject)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Nội dung thư',
                alignLabelWithHint: true,
                hintText: 'Nhập nội dung báo cáo hoặc trao đổi công việc...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
