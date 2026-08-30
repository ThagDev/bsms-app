class UserModel {
  final String userId;
  final String username;
  final String fullName;
  final String? email;
  final String? phone;
  final String? role;
  final String? department;
  final String? avatarUrl;
  final bool isLeader;

  const UserModel({
    required this.userId,
    required this.username,
    required this.fullName,
    this.email,
    this.phone,
    this.role,
    this.department,
    this.avatarUrl,
    this.isLeader = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId']?.toString() ?? json['userid']?.toString() ?? json['ID']?.toString() ?? '',
      username: json['username']?.toString() ?? json['UserName']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['FullName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? json['Email']?.toString(),
      phone: json['phone']?.toString() ?? json['Phone']?.toString(),
      role: json['role']?.toString() ?? json['Role']?.toString() ?? 'Kỹ thuật viên',
      department: json['department']?.toString() ?? json['Department']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      isLeader: json['isLeader'] == true || json['IsLeader'] == 1 || (json['role']?.toString().toLowerCase().contains('leader') ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'avatarUrl': avatarUrl,
      'isLeader': isLeader,
    };
  }
}
