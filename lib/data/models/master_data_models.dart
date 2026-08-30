class ProvinceModel {
  final String provinceId;
  final String provinceName;

  const ProvinceModel({
    required this.provinceId,
    required this.provinceName,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      provinceId: json['provinceId']?.toString() ?? json['province_id']?.toString() ?? json['ID']?.toString() ?? '',
      provinceName: json['provinceName']?.toString() ?? json['province_name']?.toString() ?? json['Name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toDbMap() => {
    'province_id': provinceId,
    'province_name': provinceName,
  };
}

class CustomerModel {
  final String customerId;
  final String customerName;
  final String? code;
  final String? phone;
  final String? address;

  const CustomerModel({
    required this.customerId,
    required this.customerName,
    this.code,
    this.phone,
    this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customerId']?.toString() ?? json['customer_id']?.toString() ?? json['ID']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? json['customer_name']?.toString() ?? json['Name']?.toString() ?? '',
      code: json['code']?.toString() ?? json['Code']?.toString(),
      phone: json['phone']?.toString() ?? json['Phone']?.toString(),
      address: json['address']?.toString() ?? json['Address']?.toString(),
    );
  }

  Map<String, dynamic> toDbMap() => {
    'customer_id': customerId,
    'customer_name': customerName,
    'code': code,
    'phone': phone,
    'address': address,
  };
}

class ErrorItemModel {
  final String errorId;
  final String errorName;
  final String? errorCode;
  final String? description;

  const ErrorItemModel({
    required this.errorId,
    required this.errorName,
    this.errorCode,
    this.description,
  });

  factory ErrorItemModel.fromJson(Map<String, dynamic> json) {
    return ErrorItemModel(
      errorId: json['errorId']?.toString() ?? json['error_id']?.toString() ?? json['ID']?.toString() ?? '',
      errorName: json['errorName']?.toString() ?? json['error_name']?.toString() ?? json['Name']?.toString() ?? '',
      errorCode: json['errorCode']?.toString() ?? json['error_code']?.toString() ?? json['Code']?.toString(),
      description: json['description']?.toString() ?? json['Description']?.toString(),
    );
  }

  Map<String, dynamic> toDbMap() => {
    'error_id': errorId,
    'error_name': errorName,
    'error_code': errorCode,
    'description': description,
  };
}

class ContactModel {
  final String contactId;
  final String name;
  final String phone;
  final String? email;
  final String? role;
  final String? department;

  const ContactModel({
    required this.contactId,
    required this.name,
    required this.phone,
    this.email,
    this.role,
    this.department,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactId: json['contactId']?.toString() ?? json['contact_id']?.toString() ?? json['ID']?.toString() ?? '',
      name: json['name']?.toString() ?? json['FullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['Phone']?.toString() ?? '',
      email: json['email']?.toString() ?? json['Email']?.toString(),
      role: json['role']?.toString() ?? json['Role']?.toString(),
      department: json['department']?.toString() ?? json['Department']?.toString(),
    );
  }

  Map<String, dynamic> toDbMap() => {
    'contact_id': contactId,
    'name': name,
    'phone': phone,
    'email': email,
    'role': role,
    'department': department,
  };
}
