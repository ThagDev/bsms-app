import 'package:flutter/material.dart';
import '../../../data/models/mail_model.dart';
import '../../../data/repositories/mail_repository.dart';

class MailViewModel extends ChangeNotifier {
  final MailRepository _mailRepository;

  MailViewModel({MailRepository? mailRepository})
      : _mailRepository = mailRepository ?? MailRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MailModel> _emails = [];
  List<MailModel> get emails => _emails;

  int get unreadCount => _emails.where((m) => !m.isRead).length;

  Future<void> loadEmails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _emails = await _mailRepository.getEmails();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(String mailId) {
    _emails = _emails.map((m) {
      if (m.mailId == mailId) {
        return m.copyWith(isRead: true);
      }
      return m;
    }).toList();
    notifyListeners();
  }

  Future<bool> sendEmail({
    required String recipient,
    required String subject,
    required String content,
  }) async {
    final success = await _mailRepository.sendEmail(
      recipient: recipient,
      subject: subject,
      content: content,
    );
    if (success) {
      final newMail = MailModel(
        mailId: 'MAIL_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'me@bsi.com.vn',
        senderName: 'Tôi',
        recipient: recipient,
        subject: subject,
        content: content,
        sentDate: DateTime.now(),
        isRead: true,
      );
      _emails.insert(0, newMail);
      notifyListeners();
    }
    return success;
  }
}
