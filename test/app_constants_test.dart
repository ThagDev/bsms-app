import 'package:flutter_test/flutter_test.dart';
import 'package:bsms_flutter/core/constants/app_constants.dart';

void main() {
  group('App Constants & Function Codes Validation', () {
    test('Verify core API function codes (49 codes from APK)', () {
      expect(ApiFunctionCodes.fLogin, equals(1));
      expect(ApiFunctionCodes.fUpdateLocation, equals(2));
      expect(ApiFunctionCodes.fTicketList, equals(3));
      expect(ApiFunctionCodes.fTicketDetail, equals(4));
      expect(ApiFunctionCodes.fUpdateTicket, equals(5));
      expect(ApiFunctionCodes.fProvince, equals(7));
      expect(ApiFunctionCodes.fCustomer, equals(8));
      expect(ApiFunctionCodes.fAtmList, equals(9));
      expect(ApiFunctionCodes.fAtmDetail, equals(10));
      expect(ApiFunctionCodes.fLogout, equals(13));
      expect(ApiFunctionCodes.fTicketSearch, equals(14));
      expect(ApiFunctionCodes.fContractInformation, equals(16));
      expect(ApiFunctionCodes.fEmailList, equals(20));
      expect(ApiFunctionCodes.fUpdateAtmInfo, equals(26));
      expect(ApiFunctionCodes.fSendEmail, equals(34));
      expect(ApiFunctionCodes.fRating, equals(38));
      expect(ApiFunctionCodes.fPingServer, equals(39));
      expect(ApiFunctionCodes.fCheckVersion, equals(42));
      expect(ApiFunctionCodes.fTeamTicketList, equals(45));
      expect(ApiFunctionCodes.fAssignTicket, equals(47));
      expect(ApiFunctionCodes.fPart, equals(48));
      expect(ApiFunctionCodes.fAddRequestDevice, equals(50));
      expect(ApiFunctionCodes.fDeviceRequestByUser, equals(53));
    });

    test('Verify SQLite Database table constants matching BSI.db v26', () {
      expect(DbConstants.dbName, equals('BSI.db'));
      expect(DbConstants.dbVersion, equals(26));
      expect(DbConstants.tableCookie, equals('BSI_COOKIE'));
      expect(DbConstants.tableTicket, equals('BSI_TICKET'));
      expect(DbConstants.tableLocation, equals('BSI_LOCATION'));
      expect(DbConstants.tableProvince, equals('BSI_PROVINCE'));
      expect(DbConstants.tableCustomer, equals('BSI_CUSTOMER'));
      expect(DbConstants.tableErrorList, equals('BSI_ERRORLIST'));
      expect(DbConstants.tablePart, equals('BSI_PART'));
      expect(DbConstants.tableUserDevice, equals('BSI_USER_DEVICE'));
    });
  });
}
