# Design Spec - ViHealth - Sổ Sức Khỏe Gia Đình

## 1. Mục tiêu sản phẩm

ViHealth là ứng dụng di động giúp người dùng lưu trữ, quản lý và theo dõi thông tin sức khỏe cho bản thân và người thân trong gia đình. Ứng dụng tập trung vào quản lý hồ sơ sức khỏe, chỉ số sức khỏe, thuốc, lịch nhắc, lịch khám và tài liệu y tế.

Ứng dụng không cung cấp chẩn đoán, điều trị hoặc tư vấn y tế. Toàn bộ nội dung trong app cần thể hiện vai trò ghi chép, lưu trữ và theo dõi.

## 2. Đối tượng người dùng

- Gia đình muốn quản lý sức khỏe cho nhiều thành viên.
- Người chăm sóc bố mẹ, ông bà hoặc người thân lớn tuổi.
- Phụ huynh muốn lưu hồ sơ sức khỏe, lịch tiêm phòng và tài liệu khám bệnh của con.
- Người cần theo dõi huyết áp, đường huyết, cân nặng, thuốc hoặc lịch tái khám định kỳ.

## 3. Navigation chính

App dùng bottom navigation gồm 5 tab:

1. Trang chủ
2. Hồ sơ
3. Lịch
4. Tài liệu
5. Cài đặt

Ngoài 5 tab chính, app có các màn hình phụ:

- Onboarding
- Thêm/sửa thành viên
- Chi tiết thành viên
- Thêm chỉ số
- Thêm thuốc
- Thêm tài liệu
- Thêm lịch nhắc
- Chi tiết lần khám
- Xuất hồ sơ

## 4. Design principle

Giao diện cần tạo cảm giác:

- Tin cậy
- Riêng tư
- Gọn gàng
- Dễ dùng cho gia đình
- Không gây cảm giác bệnh lý hoặc căng thẳng
- Phù hợp với người dùng không quá rành công nghệ

Nội dung nên dùng ngôn ngữ nhẹ nhàng. Tránh khẳng định mạnh kiểu “bất thường”, “nguy hiểm”, “cảnh báo bệnh”. Với dữ liệu sức khỏe, chỉ nên gợi ý người dùng kiểm tra lại hoặc tham khảo nhân viên y tế khi cần.

## 5. Design tokens

Xem chi tiết trong `design-tokens.json` và `styles.css`.

Màu chủ đạo là xanh lá/y tế kết hợp xanh dương:

- Primary: `#1AA37A`
- Secondary: `#2F80ED`
- Background: `#F5F8FB`
- Surface: `#FFFFFF`
- Text primary: `#17212B`
- Text secondary: `#667085`

## 6. Screen detail

### 6.1. OnboardingScreen

Mục đích: giới thiệu nhanh giá trị ứng dụng.

Nội dung chính:

- Quản lý sức khỏe cả gia đình.
- Theo dõi chỉ số và thuốc.
- Lưu tài liệu y tế riêng tư.
- Nhắc lịch uống thuốc, tái khám, tiêm phòng.

CTA chính: `Bắt đầu` hoặc `Tạo hồ sơ đầu tiên`.

### 6.2. HomeScreen

Mục đích: tổng quan sức khỏe gia đình.

Sections:

- GreetingHeader: lời chào, ngày hiện tại, avatar/tài khoản.
- FamilyMembersHorizontalList: danh sách thành viên gia đình.
- TodayReminders: thuốc/lịch/đo chỉ số cần làm hôm nay.
- QuickActionsGrid: thêm chỉ số, thêm thuốc, thêm tài liệu, thêm lịch nhắc.
- RecentMetrics: chỉ số mới ghi nhận gần đây.

### 6.3. ProfilesScreen

Mục đích: quản lý hồ sơ thành viên.

Sections:

- SearchBar.
- MemberCard list.
- AddMemberCTA.

MemberCard hiển thị:

- Avatar.
- Họ tên.
- Quan hệ.
- Tuổi.
- Ghi chú sức khỏe nổi bật.

### 6.4. MemberDetailScreen

Mục đích: màn hình trung tâm của từng thành viên.

Tabs đề xuất:

- Tổng quan
- Chỉ số
- Thuốc
- Lịch khám
- Tài liệu
- Nhắc nhở

Tổng quan cần hiển thị:

- Thông tin cá nhân.
- Dị ứng, bệnh nền, nhóm máu, ghi chú quan trọng.
- Chỉ số gần nhất.
- Thuốc đang dùng.
- Lịch sắp tới.
- Tài liệu mới nhất.

### 6.5. HealthMetricScreen

Mục đích: nhập và xem lại chỉ số sức khỏe.

Các loại chỉ số:

- Huyết áp
- Đường huyết
- Cân nặng
- Chiều cao
- Nhiệt độ
- Nhịp tim
- SpO2

Mỗi chỉ số cần có:

- Giá trị chính.
- Đơn vị.
- Thời gian đo.
- Ghi chú.
- Ngữ cảnh đo nếu cần.

### 6.6. MedicineScreen

Mục đích: quản lý thuốc và lịch uống thuốc.

Thông tin thuốc:

- Tên thuốc.
- Hàm lượng.
- Dạng thuốc.
- Liều lượng.
- Cách dùng.
- Tần suất.
- Thời gian bắt đầu/kết thúc.
- Trước/sau ăn.
- Ghi chú.

Trạng thái uống thuốc:

- Đã uống
- Chưa uống
- Bỏ qua
- Uống muộn
- Đã dừng

### 6.7. DocumentsScreen

Mục đích: lưu trữ tài liệu y tế.

Loại tài liệu:

- Đơn thuốc
- Kết quả xét nghiệm
- Giấy khám bệnh
- Giấy ra viện
- Ảnh chụp phim
- Thẻ bảo hiểm y tế
- File PDF

Actions:

- Chụp ảnh
- Chọn ảnh
- Tải file PDF
- Xem tài liệu
- Chia sẻ
- Xóa

### 6.8. HealthCalendarScreen

Mục đích: quản lý lịch sức khỏe.

Loại lịch:

- Uống thuốc
- Đo chỉ số
- Tái khám
- Tiêm phòng
- Mua thuốc
- Kiểm tra định kỳ

### 6.9. SettingsScreen

Mục đích: cấu hình app và bảo mật.

Sections:

- Khóa ứng dụng bằng PIN/sinh trắc học.
- Quản lý thông báo.
- Sao lưu dữ liệu.
- Khôi phục dữ liệu.
- Xuất hồ sơ.
- Chính sách quyền riêng tư.
- Điều khoản sử dụng.
- Xóa dữ liệu.

## 7. Component mapping

### Card

Dùng cho hồ sơ, chỉ số, thuốc, tài liệu, nhắc nhở.

Flutter equivalent:

- `Container`
- `BoxDecoration`
- `BorderRadius.circular(20)`
- border nhẹ `#E6EDF2`
- shadow nhẹ

### Bottom navigation

Flutter equivalent:

- `NavigationBar` hoặc `BottomNavigationBar`
- 5 destinations

### Quick action

Flutter equivalent:

- `InkWell`
- `Container`
- `Column`
- icon + label

### Metric card

Flutter equivalent:

- Reusable `MetricCard`
- title, value, unit, time, trend/status optional

### Reminder card

Flutter equivalent:

- Reusable `ReminderCard`
- title, member, time, status, action button

## 8. Dữ liệu mock đề xuất

Tạo mock data cho:

- 4 thành viên: Tôi, Bố, Mẹ, Bé Minh.
- 3 nhắc nhở hôm nay.
- 4 chỉ số gần nhất.
- 3 thuốc đang dùng.
- 5 tài liệu y tế.

## 9. Quy tắc triển khai

- Static UI trước, chưa cần backend.
- Không cần database ở giai đoạn này.
- Không cần authentication.
- Giữ toàn bộ text tiếng Việt.
- Tách widget/component rõ ràng.
- Ưu tiên code dễ mở rộng thành app thật.
