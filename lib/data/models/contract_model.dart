import '../../core/utils/formatters.dart';

class ContractModel {
  final String contractId;
  final String contractNo;
  final String title;
  final String customerName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final int totalAtmCount;
  final String? serviceRegion;
  final String? description;

  const ContractModel({
    required this.contractId,
    required this.contractNo,
    required this.title,
    required this.customerName,
    this.startDate,
    this.endDate,
    this.status = 'Hiệu lực',
    this.totalAtmCount = 0,
    this.serviceRegion,
    this.description,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      contractId: json['contractId']?.toString() ?? json['contractid']?.toString() ?? json['ID']?.toString() ?? '',
      contractNo: json['contractNo']?.toString() ?? json['contractno']?.toString() ?? json['ContractNo']?.toString() ?? '',
      title: json['title']?.toString() ?? json['Title']?.toString() ?? 'Hợp đồng bảo trì',
      customerName: json['customerName']?.toString() ?? json['CustomerName']?.toString() ?? '',
      startDate: Formatters.parseDate(json['startDate'] ?? json['StartDate']),
      endDate: Formatters.parseDate(json['endDate'] ?? json['EndDate']),
      status: json['status']?.toString() ?? json['Status']?.toString() ?? 'Hiệu lực',
      totalAtmCount: int.tryParse(json['totalAtmCount']?.toString() ?? json['ATMCount']?.toString() ?? '0') ?? 0,
      serviceRegion: json['serviceRegion']?.toString() ?? json['ServiceRegion']?.toString(),
      description: json['description']?.toString() ?? json['Description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractId': contractId,
      'contractNo': contractNo,
      'title': title,
      'customerName': customerName,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'totalAtmCount': totalAtmCount,
      'serviceRegion': serviceRegion,
      'description': description,
    };
  }
}
