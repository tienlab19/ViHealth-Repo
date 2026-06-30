# Codex Task - Implement ViHealth UI

Bạn là senior Flutter developer.

Hãy đọc toàn bộ các file trong folder này và implement UI app **ViHealth - Sổ Sức Khỏe Gia Đình** dựa trên prototype HTML.

## Input files

- `index.html`: HTML prototype để tham khảo bố cục giao diện.
- `styles.css`: style của prototype.
- `design-spec.md`: mô tả chi tiết màn hình, component và hành vi.
- `screens.json`: cấu trúc màn hình dạng JSON.
- `design-tokens.json`: màu sắc, spacing, radius, typography.

## Tech stack

- Flutter
- Dart
- Material 3
- Static mock data

## Goal

Convert prototype HTML thành Flutter UI có cấu trúc sạch, dễ mở rộng, dùng được làm nền cho app thật.

## Requirements

1. Implement static UI trước, chưa cần API.
2. Sử dụng mock data.
3. Giữ toàn bộ nội dung tiếng Việt.
4. Tách component rõ ràng, không viết toàn bộ UI trong một file.
5. Dùng Material 3.
6. Tạo bottom navigation gồm 5 tab:
   - Trang chủ
   - Hồ sơ
   - Lịch
   - Tài liệu
   - Cài đặt
7. Implement các màn hình:
   - OnboardingScreen
   - HomeScreen
   - ProfilesScreen
   - MemberDetailScreen
   - HealthMetricScreen
   - MedicineScreen
   - DocumentsScreen
   - HealthCalendarScreen
   - SettingsScreen
8. Màu sắc, spacing, radius và hierarchy bám theo `design-tokens.json` và `styles.css`.
9. UI cần responsive cho các kích thước điện thoại phổ biến.
10. Không implement backend, database hoặc authentication trong bước này.
11. Không thêm tính năng chẩn đoán/tư vấn y tế.
12. Với các nội dung sức khỏe, giữ wording trung tính, không dùng cảnh báo y tế mạnh.

## Suggested folder structure

```txt
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   └── app_radius.dart
│   ├── mock/
│   │   └── mock_data.dart
│   └── theme/
│       └── app_theme.dart
├── features/
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── profiles/
│   │   ├── profiles_screen.dart
│   │   └── member_detail_screen.dart
│   ├── metrics/
│   │   └── health_metric_screen.dart
│   ├── medicines/
│   │   └── medicine_screen.dart
│   ├── documents/
│   │   └── documents_screen.dart
│   ├── calendar/
│   │   └── health_calendar_screen.dart
│   └── settings/
│       └── settings_screen.dart
└── shared/
    └── widgets/
        ├── app_card.dart
        ├── app_section_header.dart
        ├── quick_action_button.dart
        ├── member_card.dart
        ├── metric_card.dart
        ├── reminder_card.dart
        ├── medicine_card.dart
        └── document_card.dart
```

## Suggested models for mock data

```dart
class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final int age;
  final String? avatar;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final String note;
}

class HealthMetric {
  final String id;
  final String memberId;
  final String type;
  final String value;
  final String unit;
  final DateTime measuredAt;
  final String? note;
}

class Medicine {
  final String id;
  final String memberId;
  final String name;
  final String dosage;
  final String instruction;
  final List<String> times;
  final String status;
}

class HealthReminder {
  final String id;
  final String memberId;
  final String title;
  final DateTime time;
  final String type;
  final bool isDone;
}

class MedicalDocument {
  final String id;
  final String memberId;
  final String title;
  final String type;
  final DateTime documentDate;
  final String? hospitalName;
}
```

## Expected output

- Flutter code compile được.
- Có `main.dart` chạy vào app shell.
- Có bottom navigation.
- Có mock data.
- Có reusable widgets.
- UI gần với prototype HTML.

## Important note

Ứng dụng chỉ phục vụ ghi chép, lưu trữ và theo dõi thông tin sức khỏe cá nhân. Không thêm nội dung chẩn đoán, điều trị hoặc tư vấn y tế.
