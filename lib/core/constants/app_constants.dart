class AppConstants {
  static const String appName = 'BSMS';
  static const String appFullName = 'Bank Service Management System';
  static const String appVersion = '2.0.0';
  static const int appVersionCode = 200;

  // Default Server Config
  static const String defaultServerIp = '115.78.3.210';
  static const int defaultServerPort = 8082;
  static const String defaultEndpoint = '/MobiFunc/Mobi.aspx';
  static const String defaultUploadEndpoint = '/MobiFunc/uploadfile.aspx';
  static const String defaultModernEndpoint = '/MobiFunc/Index';
  static const String ticketFileUploadPath = '/ckeditor/FileUpload/TicketFile/';
}

/// 49 Function Codes trích xuất từ APK BSMS (Consts.java)
class ApiFunctionCodes {
  static const int fLogin = 1;
  static const int fUpdateLocation = 2;
  static const int fTicketList = 3;
  static const int fTicketDetail = 4;
  static const int fUpdateTicket = 5;
  static const int fProvince = 7;
  static const int fCustomer = 8;
  static const int fAtmList = 9;
  static const int fAtmDetail = 10;
  static const int fErrorList = 11;
  static const int fErrorDetail = 12;
  static const int fLogout = 13;
  static const int fTicketSearch = 14;
  static const int fContractInformation = 16;
  static const int fContractSearch = 17;
  static const int fAtmContractList = 18;
  static const int fAtmTicketList = 19;
  static const int fEmailList = 20;
  static const int fEmailDetail = 21;
  static const int fContractService = 22;
  static const int fContractAtmList = 23;
  static const int fAtmFromTicket = 25;
  static const int fUpdateAtmInfo = 26;
  static const int fCheckNotification = 27;
  static const int fContactList = 28;
  static const int fDeviceByTicketId = 29;
  static const int fUpdateUserLocation = 30;
  static const int fErrorFeedback = 31;
  static const int fTicketListFromAtm = 32;
  static const int fMaintenanceSchedule = 33;
  static const int fSendEmail = 34;
  static const int fGoodsDescription = 35;
  static const int fDeviceRequest = 36;
  static const int fRating = 38;
  static const int fPingServer = 39;
  static const int fInformation = 40;
  static const int fDownloadFile = 41;
  static const int fCheckVersion = 42;
  static const int fAtmHistory = 43;
  static const int fCheckSla = 44;
  static const int fTeamTicketList = 45;
  static const int fTinhThanhVungDichVu = 46;
  static const int fAssignTicket = 47;
  static const int fPart = 48;
  static const int fDeviceRequestByTicketId = 49;
  static const int fAddRequestDevice = 50;
  static const int fTicketStatusLeader = 51;
  static const int fUpdateStatusLeader = 52;
  static const int fDeviceRequestByUser = 53;
}

/// Parameter Keys gửi lên Server Backend
class ApiParamKeys {
  static const String func = 'func';
  static const String username = 'username';
  static const String password = 'password';
  static const String cookie = 'cookie';
  static const String ticketId = 'ticketid';
  static const String ticketNo = 'ticketno';
  static const String userId = 'userid';
  static const String data = 'data';
  static const String serial = 'serial';
  static const String address = 'address';
  static const String province = 'province';
  static const String customer = 'customer';
  static const String process = 'process';
  static const String pageSize = 'pagesize';
  static const String pageNo = 'pageno';
  static const String atmId = 'atmid';
  static const String fromDate = 'fromdate';
  static const String toDate = 'todate';
  static const String contractId = 'contractid';
  static const String contractNo = 'contractno';
  static const String mailId = 'mailid';
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String log = 'log';
  static const String time = 'time';
  static const String status = 'status';
  static const String recipient = 'recipient';
  static const String serverName = 'servername';
  static const String port = 'port';
  static const String rating = 'rating';
  static const String deviceId = 'deviceid';
  static const String partId = 'partid';
  static const String content = 'content';
  static const String title = 'title';
  static const String note = 'note';
  static const String assignTo = 'assignto';
}

/// SQLite Database Constants (BSI.db schema v26)
class DbConstants {
  static const String dbName = 'BSI.db';
  static const int dbVersion = 26;

  static const String tableCookie = 'BSI_COOKIE';
  static const String tableLocation = 'BSI_LOCATION';
  static const String tableTicket = 'BSI_TICKET';
  static const String tableProvince = 'BSI_PROVINCE';
  static const String tableCustomer = 'BSI_CUSTOMER';
  static const String tableErrorList = 'BSI_ERRORLIST';
  static const String tableErrorDetail = 'BSI_ERRORDETAIL';
  static const String tableContactList = 'BSI_CONTACTLIST';
  static const String tableServerInfo = 'BSI_SERVERINFO';
  static const String tableTinhThanhVungDichVu = 'BSI_TINHTHANHVUNGDICHVU';
  static const String tablePart = 'BSI_PART';
  static const String tableUserDevice = 'BSI_USER_DEVICE';
}
