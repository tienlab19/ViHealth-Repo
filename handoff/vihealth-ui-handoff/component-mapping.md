# Component Mapping

| Prototype/CSS | Flutter widget gợi ý | Ghi chú |
|---|---|---|
| `.screen` | `Scaffold` + `SafeArea` | Mỗi màn hình app |
| `.bottom-nav` | `NavigationBar` | 5 tab chính |
| `.card` | `AppCard` custom widget | Dùng chung cho mọi card |
| `.quick-grid` / quick action | `QuickActionButton` | Icon + label + onTap |
| `.metric-card` | `MetricCard` | Chỉ số sức khỏe |
| `.member-card` | `MemberCard` | Hồ sơ thành viên |
| `.reminder-card` | `ReminderCard` | Nhắc uống thuốc/tái khám |
| `.doc-card` | `DocumentCard` | Tài liệu y tế |
| `.badge` | `Chip` hoặc custom pill | Trạng thái/nhãn |
| `.section-title` | `AppSectionHeader` | Tiêu đề section |

## Implementation note

Không cần copy nguyên HTML sang Flutter. Hãy dùng HTML như visual reference và dùng `design-spec.md`, `screens.json`, `design-tokens.json` làm nguồn cấu trúc chính.
