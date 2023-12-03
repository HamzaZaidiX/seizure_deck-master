import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:alarm/alarm.dart';

class AlarmSetupPage extends StatefulWidget {
  const AlarmSetupPage({Key? key}) : super(key: key);

  @override
  _AlarmSetupPageState createState() => _AlarmSetupPageState();
}

class _AlarmSetupPageState extends State<AlarmSetupPage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _setAlarm() async {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Schedule the alarm
    await AndroidAlarmManager.oneShot(
      alarmTime as Duration,
      0, // Replace with a unique ID for the alarm
      _alarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
    );

    // Show notification or perform other actions
    // This could be a call to your NotificationService to show the medication reminder
    // NotificationService().showMedicationReminder();
  }

  void _alarmCallback() {
    // This method will be executed when the alarm triggers
    print('Alarm triggered for medication reminder!');
    // You can show a notification or perform other actions here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set Alarm Time',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: const Text('Select Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setAlarm,
              child: const Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
