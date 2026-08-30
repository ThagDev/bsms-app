import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import 'mail_view_model.dart';
import 'mail_detail_view.dart';
import 'mail_compose_view.dart';
import '../shared_widgets/empty_state.dart';

class MailListView extends StatefulWidget {
  const MailListView({super.key});

  @override
  State<MailListView> createState() => _MailListViewState();
}

class _MailListViewState extends State<MailListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailViewModel>().loadEmails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mailVM = context.watch<MailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HÒM THƯ NỘI BỘ (F_20)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => mailVM.loadEmails(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryNavy,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MailComposeView()),
        ),
      ),
      body: mailVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : mailVM.emails.isEmpty
              ? EmptyState(
                  title: 'Hộp thư trống',
                  icon: Icons.mark_email_unread_outlined,
                  onRetry: () => mailVM.loadEmails(),
                )
              : RefreshIndicator(
                  onRefresh: () => mailVM.loadEmails(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: mailVM.emails.length,
                    itemBuilder: (context, index) {
                      final mail = mailVM.emails[index];
                      return Card(
                        color: mail.isRead ? Colors.white : Colors.blue.shade50.withOpacity(0.5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leading: CircleAvatar(
                            backgroundColor: mail.isRead ? Colors.grey.shade200 : AppTheme.primaryNavy.withOpacity(0.12),
                            child: Icon(
                              mail.isRead ? Icons.mail_outline : Icons.mark_email_unread,
                              color: mail.isRead ? Colors.grey : AppTheme.primaryNavy,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  mail.senderName,
                                  style: TextStyle(
                                    fontWeight: mail.isRead ? FontWeight.w500 : FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                Formatters.formatDate(mail.sentDate),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                mail.subject,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: mail.isRead ? FontWeight.normal : FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                mail.content,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          onTap: () {
                            mailVM.markAsRead(mail.mailId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MailDetailView(mail: mail)),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
