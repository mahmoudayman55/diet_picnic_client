# 🔔 Water Reminder Notification Troubleshooting Guide

## Common Issues & Solutions

### Issue 1: Notifications Not Appearing

#### **Solution 1: Check Permissions**
1. Go to your device Settings
2. Find your app (Diet Picnic)
3. Check if "Notifications" are enabled
4. For Android 12+, check if "Alarms & Reminders" permission is granted

#### **Solution 2: Check Battery Optimization**
1. Go to Settings → Battery
2. Find your app
3. Set battery optimization to "Unrestricted" or "Not optimized"

#### **Solution 3: Check Do Not Disturb**
1. Make sure Do Not Disturb mode is OFF
2. Or add your app to allowed apps in DND settings

#### **Solution 4: Check Notification Channel Settings (Android)**
1. Long press on your app icon
2. Tap "App info"
3. Tap "Notifications"
4. Make sure "Water Reminder" channel is enabled

---

### Issue 2: Android 12+ (API 31+) Exact Alarm Permission

Android 12+ requires special permission for exact alarms.

#### **Manual Fix:**
1. Go to Settings → Apps → Diet Picnic
2. Tap "Special app access" or "Additional permissions"
3. Find "Alarms & reminders" or "Schedule exact alarms"
4. Enable it

#### **In-App Fix:**
The app should automatically request this permission, but if it doesn't:
1. Open the Water Reminder page
2. Tap the "Check Status" button in debug tools
3. The app will request the exact alarm permission

---

### Issue 3: Notifications Scheduled but Not Triggering

#### **Check Debug Console:**
Run the app in debug mode and check for these messages:

```
🔔 Initializing notification service...
✅ Notification plugin initialized
✅ Android notification channel created
📱 Notification permission request result: true
⏰ Exact alarm permission: true
📱 Notification permission status: ✅ Granted
```

#### **Check Scheduled Notifications:**
Use the "Check Status" button in the debug tools to see:
- How many notifications are scheduled
- Their IDs and titles
- Their payloads

---

### Issue 4: Timezone Issues

The app uses UAE timezone (Asia/Dubai). If you're in a different timezone:

#### **Current Implementation:**
- All reminders are scheduled in Asia/Dubai timezone
- 8:00 AM means 8:00 AM UAE time

#### **To Change Timezone:**
Edit `lib/core/notification_service.dart` line 114:
```dart
final location = tz.getLocation('Asia/Dubai'); // Change this
```

Available timezones:
- `'Asia/Dubai'` - UAE
- `'Asia/Riyadh'` - Saudi Arabia
- `'Africa/Cairo'` - Egypt
- `'Asia/Kuwait'` - Kuwait
- etc.

---

### Issue 5: Notifications Work in Debug but Not in Release

This is usually a ProGuard/R8 issue.

#### **Solution:**
The ProGuard rules are already configured in `android/app/proguard-rules.pro`

If issues persist:
1. Clean the project: `flutter clean`
2. Rebuild: `flutter build apk --release`
3. Reinstall the app

---

## Testing Checklist

### ✅ Basic Tests

1. **Permission Test**
   - [ ] Open Water Reminder page
   - [ ] Check if permission status shows "✅ Granted"
   - [ ] If not, tap "الإعدادات" to open settings

2. **Scheduling Test**
   - [ ] Toggle on a reminder
   - [ ] Check debug console for "✅ Water reminder scheduled successfully"
   - [ ] Tap "Check Status" - should show 1 pending notification

3. **Immediate Test**
   - [ ] Tap "Test Now" button
   - [ ] Wait 1 minute
   - [ ] Notification should appear

4. **Schedule Test**
   - [ ] Tap "Test Schedule" button
   - [ ] Wait 2, 4, and 6 minutes
   - [ ] Notifications should appear at each interval

### ✅ Real Schedule Tests

1. **Today's Reminders**
   - [ ] Schedule a reminder for 2 minutes from now
   - [ ] Enable it
   - [ ] Wait and verify notification appears

2. **Tomorrow's Reminders**
   - [ ] Schedule a reminder for a time that has passed today
   - [ ] Enable it
   - [ ] Check debug console - should say "⏰ Time has passed, scheduling for tomorrow"
   - [ ] Wait until that time tomorrow

3. **Multiple Reminders**
   - [ ] Enable all 6 reminders
   - [ ] Check status - should show 6 pending notifications
   - [ ] Verify each one appears at its scheduled time

---

## Debug Console Output Examples

### ✅ Successful Scheduling:
```
📅 Attempting to schedule notification:
   ID: 1
   Title: تذكير شرب الماء 💧
   Time: 8:0
   Current time: 2024-01-15 07:30:00.000
   Scheduled time: 2024-01-15 08:00:00.000
   Time until notification: 30 minutes
✅ Water reminder scheduled successfully for 2024-01-15 08:00:00.000: تذكير شرب الماء 💧
```

### ❌ Failed Scheduling:
```
📅 Attempting to schedule notification:
   ID: 1
   Title: تذكير شرب الماء 💧
   Time: 8:0
   Current time: 2024-01-15 07:30:00.000
❌ Error scheduling water reminder: [Error details]
Stack trace: [Stack trace]
```

---

## Device-Specific Issues

### Samsung Devices
- Check "Sleeping apps" in Battery settings
- Disable "Put unused apps to sleep"
- Add app to "Never sleeping apps"

### Xiaomi/MIUI Devices
- Enable "Autostart" for the app
- Disable "Battery saver" for the app
- Enable "Display pop-up windows while running in background"

### Huawei Devices
- Enable "Autostart" for the app
- Disable "Battery optimization"
- Add to "Protected apps"

### OnePlus Devices
- Disable "Sleep standby optimization"
- Enable "Display over other apps"

---

## Quick Fix Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check for errors
flutter analyze

# Build release APK
flutter build apk --release

# Check device logs
adb logcat | grep -i notification
```

---

## Still Not Working?

1. **Check the debug console** for error messages
2. **Use the "Check Status" button** to see pending notifications
3. **Try the "Test Now" button** for immediate testing
4. **Check device notification settings** for your app
5. **Restart the device** (sometimes helps with permission issues)
6. **Uninstall and reinstall** the app (last resort)

---

## Contact Support

If none of these solutions work, please provide:
1. Device model and Android version
2. Debug console output
3. Steps to reproduce the issue
4. Screenshots of notification settings

