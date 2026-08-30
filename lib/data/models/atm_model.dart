import '../../core/utils/formatters.dart';

class AtmModel {
  final String atmId;
  final String atmCode;
  final String? serialNumber;
  final String? model;
  final String? manufacturer;
  final String? address;
  final String? province;
  final String? customerName;
  final String? customerId;
  final String status;
  final double? lat;
  final double? lng;
  final DateTime? installDate;
  final DateTime? lastMaintenanceDate;
  final String? contractNo;
  final String? ipAddress;

  const AtmModel({
    required this.atmId,
    required this.atmCode,
    this.serialNumber,
    this.model,
    this.manufacturer,
    this.address,
    this.province,
    this.customerName,
    this.customerId,
    this.status = 'Hoạt động',
    this.lat,
    this.lng,
    this.installDate,
    this.lastMaintenanceDate,
    this.contractNo,
    this.ipAddress,
  });

  factory AtmModel.fromJson(Map<String, dynamic> json) {
    return AtmModel(
      atmId: json['atmId']?.toString() ?? json['atmid']?.toString() ?? json['ID']?.toString() ?? '',
      atmCode: json['atmCode']?.toString() ?? json['atm_code']?.toString() ?? json['Code']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? json['serial']?.toString() ?? json['Serial']?.toString(),
      model: json['model']?.toString() ?? json['Model']?.toString(),
      manufacturer: json['manufacturer']?.toString() ?? json['Manufacturer']?.toString(),
      address: json['address']?.toString() ?? json['Address']?.toString(),
      province: json['province']?.toString() ?? json['Province']?.toString(),
      customerName: json['customerName']?.toString() ?? json['CustomerName']?.toString(),
      customerId: json['customerId']?.toString() ?? json['CustomerId']?.toString(),
      status: json['status']?.toString() ?? json['Status']?.toString() ?? 'Hoạt động',
      lat: double.tryParse(json['lat']?.toString() ?? ''),
      lng: double.tryParse(json['lng']?.toString() ?? ''),
      installDate: Formatters.parseDate(json['installDate'] ?? json['InstallDate']),
      lastMaintenanceDate: Formatters.parseDate(json['lastMaintenanceDate'] ?? json['LastMaintenanceDate']),
      contractNo: json['contractNo']?.toString() ?? json['ContractNo']?.toString(),
      ipAddress: json['ipAddress']?.toString() ?? json['IPAddress']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atmId': atmId,
      'atmCode': atmCode,
      'serialNumber': serialNumber,
      'model': model,
      'manufacturer': manufacturer,
      'address': address,
      'province': province,
      'customerName': customerName,
      'customerId': customerId,
      'status': status,
      'lat': lat,
      'lng': lng,
      'installDate': installDate?.toIso8601String(),
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'contractNo': contractNo,
      'ipAddress': ipAddress,
    };
  }
}
