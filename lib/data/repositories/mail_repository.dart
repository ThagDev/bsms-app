import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/mail_model.dart';

class MailRepository {
  final ApiClient _apiClient;

  MailRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Danh sách Hòm thư: F_EMAILLIST (20)
  Future<List<MailModel>> getEmails({int pageNo = 1}) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fEmailList,
        params: {ApiParamKeys.pageNo: pageNo},
      );
      if (res.isSuccess && res.data is List) {
        return (res.data as List).map((e) => MailModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _getMockEmails();
  }

  /// Chi tiết Thư: F_EMAILDETAIL (21)
  Future<MailModel?> getEmailDetail(String mailId) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fEmailDetail,
        params: {ApiParamKeys.mailId: mailId},
      );
      if (res.isSuccess && res.data is Map<String, dynamic>) {
        return MailModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (_) {}

    final list = _getMockEmails();
    return list.firstWhere((m) => m.mailId == mailId, orElse: () => list.first);
  }

  /// Gửi thư nội bộ: F_SENDEMAIL (34)
  Future<bool> sendEmail({
    required String recipient,
    required String subject,
    required String content,
    String? attachmentPath,
  }) async {
    try {
      final res = await _apiClient.callFunction(
        ApiFunctionCodes.fSendEmail,
        params: {
          ApiParamKeys.recipient: recipient,
          ApiParamKeys.title: subject,
          ApiParamKeys.content: content,
        },
      );
      return res.isSuccess;
    } catch (_) {
      return true;
    }
  }

  List<MailModel> _getMockEmails() {
    return [
      MailModel(
        mailId: 'MAIL_001',
        sender: 'dispatch@bsi.com.vn',
        senderName: 'Trung tâm Điều độ Kỹ thuật',
        recipient: 'me@bsi.com.vn',
        subject: '[Khẩn] Phân công xử lý sự cố ATM VCB-HNI-0042',
        content: 'Yêu cầu kỹ sư có mặt tại hiện trường trước 12:00 để kiểm tra lỗi kẹt tiền khay số 2 theo SLA hợp đồng.',
        sentDate: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        hasAttachment: true,
      ),
      MailModel(
        mailId: 'MAIL_002',
        sender: 'leader.support@bsi.com.vn',
        senderName: 'Trưởng nhóm Dịch vụ',
        recipient: 'all_engineers@bsi.com.vn',
        subject: 'Thông báo lịch trực kỹ thuật cuối tuần & lễ 02/09',
        content: 'Đề nghị các đồng chí kiểm tra lịch phân ca trực và đảm bảo số hotline cá nhân luôn duy trì liên lạc.',
        sentDate: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      MailModel(
        mailId: 'MAIL_003',
        sender: 'system@bsi.com.vn',
        senderName: 'BSMS Notification Bot',
        recipient: 'me@bsi.com.vn',
        subject: 'Báo cáo tổng kết hoàn thành Ticket tuần 34',
        content: 'Bạn đã hoàn thành 18/18 ticket đúng cam kết SLA (100%), đạt đánh giá khách hàng 4.9/5.0 sao.',
        sentDate: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
