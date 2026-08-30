import '../../core/utils/formatters.dart';

class MailModel {
  final String mailId;
  final String sender;
  final String senderName;
  final String recipient;
  final String subject;
  final String content;
  final DateTime? sentDate;
  final bool isRead;
  final bool hasAttachment;
  final String? attachmentUrl;

  const MailModel({
    required this.mailId,
    required this.sender,
    required this.senderName,
    required this.recipient,
    required this.subject,
    required this.content,
    this.sentDate,
    this.isRead = false,
    this.hasAttachment = false,
    this.attachmentUrl,
  });

  factory MailModel.fromJson(Map<String, dynamic> json) {
    return MailModel(
      mailId: json['mailId']?.toString() ?? json['mailid']?.toString() ?? json['ID']?.toString() ?? '',
      sender: json['sender']?.toString() ?? json['Sender']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? json['SenderName']?.toString() ?? json['sender']?.toString() ?? 'Hệ thống',
      recipient: json['recipient']?.toString() ?? json['Recipient']?.toString() ?? '',
      subject: json['subject']?.toString() ?? json['Subject']?.toString() ?? '(Không tiêu đề)',
      content: json['content']?.toString() ?? json['Content']?.toString() ?? json['Body']?.toString() ?? '',
      sentDate: Formatters.parseDate(json['sentDate'] ?? json['SentDate'] ?? json['Date']),
      isRead: json['isRead'] == true || json['IsRead'] == 1,
      hasAttachment: json['hasAttachment'] == true || json['HasAttachment'] == 1,
      attachmentUrl: json['attachmentUrl']?.toString() ?? json['AttachmentUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mailId': mailId,
      'sender': sender,
      'senderName': senderName,
      'recipient': recipient,
      'subject': subject,
      'content': content,
      'sentDate': sentDate?.toIso8601String(),
      'isRead': isRead,
      'hasAttachment': hasAttachment,
      'attachmentUrl': attachmentUrl,
    };
  }

  MailModel copyWith({bool? isRead}) {
    return MailModel(
      mailId: mailId,
      sender: sender,
      senderName: senderName,
      recipient: recipient,
      subject: subject,
      content: content,
      sentDate: sentDate,
      isRead: isRead ?? this.isRead,
      hasAttachment: hasAttachment,
      attachmentUrl: attachmentUrl,
    );
  }
}
