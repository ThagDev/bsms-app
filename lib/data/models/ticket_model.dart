import '../../core/utils/formatters.dart';

class TicketModel {
  final String ticketId;
  final String ticketNo;
  final String title;
  final String content;
  final String status;
  final String priority;
  final String? atmId;
  final String? atmCode;
  final String? customerId;
  final String? customerName;
  final String? address;
  final DateTime? createdDate;
  final DateTime? slaDueDate;
  final String? assignedTo;
  final String? assignedToName;
  final String? errorId;
  final String? errorName;
  final int? rating;
  final String? feedbackNote;

  const TicketModel({
    required this.ticketId,
    required this.ticketNo,
    required this.title,
    required this.content,
    required this.status,
    this.priority = 'Bình thường',
    this.atmId,
    this.atmCode,
    this.customerId,
    this.customerName,
    this.address,
    this.createdDate,
    this.slaDueDate,
    this.assignedTo,
    this.assignedToName,
    this.errorId,
    this.errorName,
    this.rating,
    this.feedbackNote,
  });

  bool get isSlaOverdue {
    if (slaDueDate == null) return false;
    return DateTime.now().isAfter(slaDueDate!);
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticketId']?.toString() ?? json['ticket_id']?.toString() ?? json['ID']?.toString() ?? '',
      ticketNo: json['ticketNo']?.toString() ?? json['ticket_no']?.toString() ?? json['TicketNo']?.toString() ?? '',
      title: json['title']?.toString() ?? json['Title']?.toString() ?? json['Subject']?.toString() ?? 'Sự cố thiết bị',
      content: json['content']?.toString() ?? json['Content']?.toString() ?? json['Description']?.toString() ?? '',
      status: json['status']?.toString() ?? json['Status']?.toString() ?? 'Chờ xử lý',
      priority: json['priority']?.toString() ?? json['Priority']?.toString() ?? 'Bình thường',
      atmId: json['atmId']?.toString() ?? json['atm_id']?.toString() ?? json['AtmId']?.toString(),
      atmCode: json['atmCode']?.toString() ?? json['atm_code']?.toString() ?? json['AtmCode']?.toString(),
      customerId: json['customerId']?.toString() ?? json['customer_id']?.toString() ?? json['CustomerId']?.toString(),
      customerName: json['customerName']?.toString() ?? json['customer_name']?.toString() ?? json['CustomerName']?.toString(),
      address: json['address']?.toString() ?? json['Address']?.toString(),
      createdDate: Formatters.parseDate(json['createdDate'] ?? json['created_date'] ?? json['CreatedDate']),
      slaDueDate: Formatters.parseDate(json['slaDueDate'] ?? json['sla_due_date'] ?? json['SLADueDate']),
      assignedTo: json['assignedTo']?.toString() ?? json['assigned_to']?.toString() ?? json['AssignedTo']?.toString(),
      assignedToName: json['assignedToName']?.toString() ?? json['assigned_to_name']?.toString() ?? json['AssignedToName']?.toString(),
      errorId: json['errorId']?.toString() ?? json['error_id']?.toString() ?? json['ErrorId']?.toString(),
      errorName: json['errorName']?.toString() ?? json['error_name']?.toString() ?? json['ErrorName']?.toString(),
      rating: int.tryParse(json['rating']?.toString() ?? ''),
      feedbackNote: json['feedbackNote']?.toString() ?? json['feedback_note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'ticketNo': ticketNo,
      'title': title,
      'content': content,
      'status': status,
      'priority': priority,
      'atmId': atmId,
      'atmCode': atmCode,
      'customerId': customerId,
      'customerName': customerName,
      'address': address,
      'createdDate': createdDate?.toIso8601String(),
      'slaDueDate': slaDueDate?.toIso8601String(),
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
      'errorId': errorId,
      'errorName': errorName,
      'rating': rating,
      'feedbackNote': feedbackNote,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'ticket_id': ticketId,
      'ticket_no': ticketNo,
      'title': title,
      'content': content,
      'status': status,
      'priority': priority,
      'atm_id': atmId,
      'atm_code': atmCode,
      'customer_id': customerId,
      'customer_name': customerName,
      'address': address,
      'created_date': createdDate?.toIso8601String(),
      'sla_due_date': slaDueDate?.toIso8601String(),
      'assigned_to': assignedTo,
      'updated_date': DateTime.now().toIso8601String(),
      'raw_json': null,
    };
  }

  TicketModel copyWith({
    String? status,
    String? assignedTo,
    String? assignedToName,
    int? rating,
    String? feedbackNote,
  }) {
    return TicketModel(
      ticketId: ticketId,
      ticketNo: ticketNo,
      title: title,
      content: content,
      status: status ?? this.status,
      priority: priority,
      atmId: atmId,
      atmCode: atmCode,
      customerId: customerId,
      customerName: customerName,
      address: address,
      createdDate: createdDate,
      slaDueDate: slaDueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToName: assignedToName ?? this.assignedToName,
      errorId: errorId,
      errorName: errorName,
      rating: rating ?? this.rating,
      feedbackNote: feedbackNote ?? this.feedbackNote,
    );
  }
}
