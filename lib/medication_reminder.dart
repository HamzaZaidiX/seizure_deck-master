import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '/services/AlarmSetupPage.dart';

class medicationReminder extends StatefulWidget {
  const medicationReminder({Key? key}) : super(key: key);

  @override
  _medicationReminderWidgetState createState() =>
      _medicationReminderWidgetState();
}

class _medicationReminderWidgetState extends State<medicationReminder> {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();
    var scheduledTimeZone = tz.local;

    // Convert the DateTime object to a TZDateTime
    var scheduledDateTime = tz.TZDateTime.from(
      scheduledTime,
      scheduledTimeZone,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder', // Title
      "It's time to take your medicine!", // Body
      scheduledDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
    );
  }

  TextEditingController textController = TextEditingController();
  DateTime? datePicked1;
  DateTime? datePicked2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this section with your image and design
            Image.network(
              'https://images.unsplash.com/photo-1549477752-31cd7327aed0?w=1280&h=720',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Text('Medicine Name', style: TextStyle(fontSize: 24)),

            Text('Details of Medicine', style: TextStyle(fontSize: 18)),

            // Text input field
            const Text(
              "Enter Medicine",
              style: TextStyle(
                  color: Color(0xFF454587),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                      hintText: ("Enter Medicine"),
                    ),
                  ),
                ],
              ),
            ),
            // Select Date Button
            TextButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if (date != null) {
                  setState(() {
                    datePicked1 = date;
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF454587),
                padding: EdgeInsets.symmetric(horizontal: 15.0), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Button shape
                  side:
                      BorderSide(width: 5, color: Color(0xFF454587)), // Border
                ),
              ),
              child: const Text(
                "Select Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // Select Time Button
            TextButton(
              onPressed: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                 if (selectedTime != null) {
                  final now = DateTime.now();
                  final scheduledDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  await _scheduleNotification(scheduledDateTime);
                }
                          

                if (selectedTime != null) {
                  setState(() {
                    datePicked2 = DateTime(
                      datePicked2!.year,
                      datePicked2!.month,
                      datePicked2!.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF454587),
                padding: EdgeInsets.symmetric(horizontal: 15.0), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Button shape
                  side:
                      BorderSide(width: 5, color: Color(0xFF454587)), // Border
                ),
              ),
              child: const Text(
                "Select Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // Set Reminder Button
            ElevatedButton(
              child: const Text('Set Reminder'),
              onPressed: () {
                if (datePicked1 != null) {
                  // Compare the selected date with the current date and time
                  final currentTime = DateTime.now();
                  if (datePicked1!.isAfter(currentTime)) {
                    // Format the date and time
                    String formattedDate = DateFormat('dd/MM/yy').format(datePicked1!);
                    String formattedTime = DateFormat('HH:mm').format(datePicked2!);

                    // The selected date is in the future, so set the reminder
                    NotificationService().showNotification(
                      title: 'Reminder',
                      body: 'Your Reminder has been set for $formattedDate at $formattedTime',
                    );
                     
                  } else {
                    // The selected date is in the past, show an error message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Invalid Date'),
                          content: const Text(
                              'Please select a future Date and Time to set a reminder!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Handle the case where the date & time is not selected
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Date Not Selected'),
                        content: const Text(
                            'Please select a Date and Time to set a reminder.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlarmSetupPage(),
              ),
            );
          },
          child: const Text('Set Alarm'),
        ),

          ],
        ),
      ),
    );
  }
}
