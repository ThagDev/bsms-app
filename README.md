# BSMS - Bank Service Management System (Flutter)

Hệ thống quản lý dịch vụ kỹ thuật ATM, hợp đồng và sự cố (Ticket) được tái thiết kế và xây dựng trên nền tảng Flutter / Dart với kiến trúc Clean Architecture / MVVM.

## Phân hệ chính
- 📊 **Bảng điều hành Kỹ thuật (Dashboard)**: Thống kê KPI, cảnh báo quá hạn SLA, điều phối hiện trường.
- 🎫 **Quản lý Sự cố (Tickets)**: Bao phủ đầy đủ các hàm F_TICKETLIST, F_TICKETDETAIL, F_UPDATETICKET, F_ASSIGNTICKET, F_CHECKSLA, F_RATING.
- 🏧 **Quản lý Trạm ATM**: Tra cứu, thông số phần cứng, lịch sử sửa chữa và cập nhật vị trí GPS (F_ATMLIST, F_ATMDETAIL, F_UPDATEATMINFO).
- 📜 **Hợp đồng & Dịch vụ**: Quản lý phạm vi dịch vụ, bảo dưỡng định kỳ và danh sách ATM liên kết (F_CONTRACTSEARCH, F_CONTRACTSERVICE).
- ✉️ **Hòm thư Nội bộ**: Giao tiếp điều độ kỹ thuật, đính kèm tệp tin sự cố (F_EMAILLIST, F_SENDEMAIL).
- 🔧 **Kho Linh kiện & Vật tư**: Quản lý tồn kho và tạo phiếu đề xuất cấp phát thiết bị thay thế (F_PART, F_ADD_REQUEST_DEVICE).
- ⚙️ **Cài đặt & Đồng bộ Offline**: Cấu hình IP/Port máy chủ linh hoạt, tự động đồng bộ vào SQLite (BSI.db v26).

## Tự động Build CI/CD
Dự án được cấu hình GitHub Actions (`.github/workflows/build_ios.yml`) để tự động build file **`.ipa` (iOS)** và **`.apk` (Android)** trên đám mây mỗi khi có commit mới.
