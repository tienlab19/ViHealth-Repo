# ViHealth UI Handoff

Gói này là bộ bàn giao giao diện cho app **ViHealth - Sổ Sức Khỏe Gia Đình** để review và đưa vào Codex xử lý.

## Nội dung

- `index.html`: prototype HTML đã tách CSS, mở trực tiếp để review UI.
- `styles.css`: toàn bộ style/design token dạng CSS.
- `prototype-standalone.html`: bản HTML độc lập, đã nhúng CSS, tiện mở nhanh.
- `design-spec.md`: mô tả chi tiết màn hình, navigation, component và hành vi UI.
- `screens.json`: cấu trúc màn hình dạng machine-readable để Codex dễ parse.
- `design-tokens.json`: màu sắc, spacing, radius, typography.
- `codex-task.md`: prompt/yêu cầu kỹ thuật để Codex implement Flutter UI.
- `docs/`: tài liệu mô tả sản phẩm gốc dạng PDF/DOCX.

## Cách review

Mở `index.html` hoặc `prototype-standalone.html` bằng trình duyệt.

## Cách đưa cho Codex

Upload toàn bộ folder hoặc file zip này vào Codex, sau đó dùng prompt trong `codex-task.md`.
