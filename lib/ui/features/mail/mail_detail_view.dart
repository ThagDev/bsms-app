import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/mail_model.dart';

class MailDetailView extends StatelessWidget {
  final MailModel mail;

  const MailDetailView({super.key, required this.mail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Thư (F_21)')),
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
                    Text(
                      mail.subject,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryNavy.withOpacity(0.1),
                          child: const Icon(Icons.person, color: AppTheme.primaryNavy),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mail.senderName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Từ: ${mail.sender}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              Text('Tới: ${mail.recipient}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(
                          Formatters.formatDateTime(mail.sentDate),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  mail.content,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),

            if (mail.hasAttachment) ...[
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                color: Colors.grey.shade50,
                child: ListTile(
                  leading: const Icon(Icons.attach_file, color: AppTheme.primaryNavy),
                  title: const Text('Tệp đính kèm: Tai_lieu_su_co.pdf', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('2.4 MB • F_41 (Download)'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đang tải tệp đính kèm (F_DOWNLOADFILE)...')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
