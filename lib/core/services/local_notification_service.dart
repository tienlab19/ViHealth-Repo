import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/family/domain/entities/reminder.dart';

class LocalNotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'vihealth_reminders';
  static const _channelName = 'Lịch nhắc sức khỏe';
  static const _channelDescription =
      'Nhắc uống thuốc, đo chỉ số, tái khám, tiêm phòng và mua thuốc.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _supported = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _supported = _isSupportedPlatform;
    if (!_supported) return;

    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Mở ViHealth',
    );
    const windowsSettings = WindowsInitializationSettings(
      appName: 'ViHealth',
      appUserModelId: 'com.example.vihealth',
      guid: '5e5f0b0a-8f29-4f49-9b4f-fc0e5f2c2a30',
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
        linux: linuxSettings,
        windows: windowsSettings,
      ),
    );

    await _requestPermissions();
  }

  Future<void> syncReminders(List<Reminder> reminders) async {
    if (!await _ensureReady()) return;
    for (final reminder in reminders) {
      if (reminder.isEnabled) {
        await scheduleReminder(reminder);
      } else {
        await cancelReminder(reminder.id);
      }
    }
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    if (!await _ensureReady()) return;
    await cancelReminder(reminder.id);
    if (!reminder.isEnabled) return;

    final scheduledAt = _nextDailyReminder(reminder.timeText);
    if (scheduledAt == null) return;

    await _plugin.zonedSchedule(
      _notificationId(reminder.id),
      reminder.title,
      reminder.description.isEmpty
          ? _reminderTypeLabel(reminder.type)
          : reminder.description,
      scheduledAt,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: reminder.id,
    );
  }

  Future<void> cancelReminder(String reminderId) async {
    if (!await _ensureReady()) return;
    await _plugin.cancel(_notificationId(reminderId));
  }

  Future<bool> _ensureReady() async {
    if (!_initialized) await initialize();
    return _supported;
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  bool get _isSupportedPlatform {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      TargetPlatform.linux ||
      TargetPlatform.windows ||
      TargetPlatform.fuchsia => false,
    };
  }
}

tz.TZDateTime? _nextDailyReminder(String timeText) {
  final parts = timeText.trim().split(':');
  if (parts.length != 2) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

  final now = tz.TZDateTime.now(tz.local);
  var scheduledAt = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );
  if (!scheduledAt.isAfter(now)) {
    scheduledAt = scheduledAt.add(const Duration(days: 1));
  }
  return scheduledAt;
}

int _notificationId(String reminderId) {
  var hash = 0x811c9dc5;
  for (final unit in reminderId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0x7fffffff;
  }
  return hash;
}

String _reminderTypeLabel(ReminderType type) {
  return switch (type) {
    ReminderType.medicine => 'Đến giờ uống thuốc',
    ReminderType.metric => 'Đến giờ đo chỉ số',
    ReminderType.appointment => 'Sắp tới lịch tái khám',
    ReminderType.vaccine => 'Đến lịch tiêm phòng',
    ReminderType.buyMedicine => 'Nhắc mua thuốc',
  };
}
