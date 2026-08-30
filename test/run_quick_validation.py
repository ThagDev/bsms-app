import os
import re
import sys

print("=" * 60)
print("🚀 BẮT ĐẦU KIỂM THỬ TOÀN DIỆN MÃ NGUỒN BSMS (FLUTTER/DART)")
print("=" * 60)

passed_tests = 0
failed_tests = 0

def assert_test(name, condition, details=""):
    global passed_tests, failed_tests
    if condition:
        print(f"  ✅ [PASS] {name}")
        passed_tests += 1
    else:
        print(f"  ❌ [FAIL] {name}: {details}")
        failed_tests += 1

# 1. Kiểm tra sự tồn tại của các thư mục và tệp cốt lõi
print("\n1. Kiểm tra cấu trúc thư mục & tệp tin:")
core_files = [
    "pubspec.yaml",
    "lib/main.dart",
    "lib/core/constants/app_constants.dart",
    "lib/core/network/api_client.dart",
    "lib/core/database/database_helper.dart",
    "lib/core/theme/app_theme.dart",
    "lib/core/utils/formatters.dart",
    "lib/data/models/user_model.dart",
    "lib/data/models/ticket_model.dart",
    "lib/data/models/atm_model.dart",
    "lib/data/models/contract_model.dart",
    "lib/data/models/mail_model.dart",
    "lib/data/models/part_model.dart",
    "lib/data/models/master_data_models.dart",
    "lib/data/repositories/auth_repository.dart",
    "lib/data/repositories/ticket_repository.dart",
    "lib/data/repositories/atm_repository.dart",
    "lib/data/repositories/contract_repository.dart",
    "lib/data/repositories/mail_repository.dart",
    "lib/data/repositories/part_repository.dart",
    "lib/data/repositories/master_data_repository.dart",
    "lib/ui/features/auth/login_view.dart",
    "lib/ui/features/home/home_dashboard_view.dart",
    "lib/ui/features/tickets/ticket_list_view.dart",
    "lib/ui/features/tickets/ticket_detail_view.dart",
    "lib/ui/features/atm/atm_list_view.dart",
    "lib/ui/features/atm/atm_detail_view.dart",
    "lib/ui/features/contracts/contract_list_view.dart",
    "lib/ui/features/mail/mail_list_view.dart",
    "lib/ui/features/parts/part_list_view.dart",
    "lib/ui/features/settings/settings_view.dart",
    "lib/ui/features/navigation/main_navigation_scaffold.dart",
    "test/app_constants_test.dart",
    "test/models_test.dart",
]

for f in core_files:
    exists = os.path.isfile(f)
    assert_test(f"File tồn tại: {f}", exists)

# 2. Kiểm tra 49 API function codes trong app_constants.dart
print("\n2. Kiểm tra 49 Function Codes (F_*):")
with open("lib/core/constants/app_constants.dart", "r", encoding="utf-8") as f:
    constants_content = f.read()

expected_funcs = [
    ("fLogin", 1), ("fUpdateLocation", 2), ("fTicketList", 3), ("fTicketDetail", 4),
    ("fUpdateTicket", 5), ("fProvince", 7), ("fCustomer", 8), ("fAtmList", 9),
    ("fAtmDetail", 10), ("fErrorList", 11), ("fErrorDetail", 12), ("fLogout", 13),
    ("fTicketSearch", 14), ("fContractInformation", 16), ("fContractSearch", 17),
    ("fAtmContractList", 18), ("fAtmTicketList", 19), ("fEmailList", 20),
    ("fEmailDetail", 21), ("fContractService", 22), ("fContractAtmList", 23),
    ("fAtmFromTicket", 25), ("fUpdateAtmInfo", 26), ("fCheckNotification", 27),
    ("fContactList", 28), ("fDeviceByTicketId", 29), ("fUpdateUserLocation", 30),
    ("fErrorFeedback", 31), ("fTicketListFromAtm", 32), ("fMaintenanceSchedule", 33),
    ("fSendEmail", 34), ("fGoodsDescription", 35), ("fDeviceRequest", 36),
    ("fRating", 38), ("fPingServer", 39), ("fInformation", 40), ("fDownloadFile", 41),
    ("fCheckVersion", 42), ("fAtmHistory", 43), ("fCheckSla", 44), ("fTeamTicketList", 45),
    ("fTinhThanhVungDichVu", 46), ("fAssignTicket", 47), ("fPart", 48),
    ("fDeviceRequestByTicketId", 49), ("fAddRequestDevice", 50),
    ("fTicketStatusLeader", 51), ("fUpdateStatusLeader", 52), ("fDeviceRequestByUser", 53)
]

for func_name, code in expected_funcs:
    pattern = rf"static const int {func_name}\s*=\s*{code};"
    match = re.search(pattern, constants_content)
    assert_test(f"Function Code {func_name} == {code}", match is not None)

# 3. Kiểm tra Schema SQLite (12 Bảng)
print("\n3. Kiểm tra 12 bảng DatabaseHelper (BSI.db v26):")
with open("lib/core/database/database_helper.dart", "r", encoding="utf-8") as f:
    db_content = f.read()

expected_tables = [
    "tableCookie", "tableLocation", "tableTicket", "tableProvince",
    "tableCustomer", "tableErrorList", "tableErrorDetail", "tableContactList",
    "tableServerInfo", "tableTinhThanhVungDichVu", "tablePart", "tableUserDevice"
]

for table in expected_tables:
    assert_test(f"Bảng SQLite: {table}", f"DbConstants.{table}" in db_content)

# 4. Kiểm tra Dart syntax / braces matching
print("\n4. Kiểm tra tính toàn vẹn cú pháp Dart:")
dart_files = []
for root, _, files in os.walk("lib"):
    for file in files:
        if file.endswith(".dart"):
            dart_files.append(os.path.join(root, file))

for df in dart_files:
    with open(df, "r", encoding="utf-8") as f:
        content = f.read()
    open_braces = content.count("{")
    close_braces = content.count("}")
    assert_test(f"Dấu ngoặc chuẩn: {os.path.basename(df)} ({open_braces} open / {close_braces} close)", open_braces == close_braces)

print("\n" + "=" * 60)
print(f"📊 KẾT QUẢ KIỂM THỬ: {passed_tests} PASS / {failed_tests} FAIL")
print("=" * 60)

if failed_tests > 0:
    sys.exit(1)
