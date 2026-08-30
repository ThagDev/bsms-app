class PartModel {
  final String partId;
  final String partCode;
  final String partName;
  final int quantity;
  final String unit;
  final String? description;

  const PartModel({
    required this.partId,
    required this.partCode,
    required this.partName,
    this.quantity = 0,
    this.unit = 'Cái',
    this.description,
  });

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return PartModel(
      partId: json['partId']?.toString() ?? json['part_id']?.toString() ?? json['ID']?.toString() ?? '',
      partCode: json['partCode']?.toString() ?? json['part_code']?.toString() ?? json['Code']?.toString() ?? '',
      partName: json['partName']?.toString() ?? json['part_name']?.toString() ?? json['Name']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString() ?? 'Cái',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partId': partId,
      'partCode': partCode,
      'partName': partName,
      'quantity': quantity,
      'unit': unit,
      'description': description,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'part_id': partId,
      'part_code': partCode,
      'part_name': partName,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

class DeviceRequestModel {
  final String requestId;
  final String ticketId;
  final String partId;
  final String partName;
  final int quantity;
  final String status;
  final String? note;
  final DateTime? requestDate;

  const DeviceRequestModel({
    required this.requestId,
    required this.ticketId,
    required this.partId,
    required this.partName,
    required this.quantity,
    this.status = 'Chờ duyệt',
    this.note,
    this.requestDate,
  });

  factory DeviceRequestModel.fromJson(Map<String, dynamic> json) {
    return DeviceRequestModel(
      requestId: json['requestId']?.toString() ?? json['ID']?.toString() ?? '',
      ticketId: json['ticketId']?.toString() ?? json['ticketid']?.toString() ?? '',
      partId: json['partId']?.toString() ?? json['partid']?.toString() ?? '',
      partName: json['partName']?.toString() ?? json['PartName']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      status: json['status']?.toString() ?? 'Chờ duyệt',
      note: json['note']?.toString(),
    );
  }
}
