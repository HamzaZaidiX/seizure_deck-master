import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '/services/AlarmSetupPage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class medicationReminder extends StatefulWidget {
  const medicationReminder({Key? key}) : super(key: key);

  @override
  _medicationReminderWidgetState createState() =>
      _medicationReminderWidgetState();
}

class _medicationReminderWidgetState extends State<medicationReminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> reminderOptions = [
    'Everyday',
    'Every X Days',
    'Days of Week',
    'Any',
  ];

  String selectedOption = 'Everyday';

  int selectedIndex = 0;

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
        title: Text('Add New Medication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Medication Name input field
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medication Name',
                      style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        hintText: ("Enter Medicine"),
                      ),
                    ),
                  ],
                ),
              ),

              // Textfield for Dosage
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dosage',
                      style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        hintText: ("Enter Dosage in ml"),
                      ),
                    ),
                  ],
                ),
              ),

              // Dropdown for Reminder Options
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequency',
                      style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue!;
                        });
                      },
                      items: reminderOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medicine Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF454587),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the spacing as needed

                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Adjust this based on your spacing preference
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(MdiIcons.medication),
                              onPressed: () {
                                // Add your functionality here
                              },
                              iconSize: 30, // Set the icon size
                            ),
                            const SizedBox(
                                height: 10), // Adding a space of 10px
                            Text("Syrup"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(MdiIcons.pill),
                              onPressed: () {
                                // Add your functionality here
                              },
                              iconSize: 30, // Set the icon size
                            ),
                            const SizedBox(
                                height: 10), // Adding a space of 10px
                            Text("Tablets"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(MdiIcons.needle),
                              onPressed: () {
                                // Add your functionality here
                              },
                              iconSize: 30, // Set the icon size
                            ),
                            const SizedBox(
                                height: 10), // Adding a space of 10px
                            Text("Syringe"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button shape
                        side: BorderSide(
                            width: 2, color: Color(0xFF454587)), // Border
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Button shape
                        side: BorderSide(
                            width: 2, color: Color(0xFF454587)), // Border
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
                ],
              ),

              // Toggle Switch for Reminder and Alarm
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    minWidth: 90.0,
                    minHeight: 36.0,
                    initialLabelIndex: 0,
                    activeBgColor: [Color(0xFF454587)],
                    labels: ['Reminder', 'Alarm'],
                    onToggle: (index) {
                      // Handle the toggle switch change
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Set Reminder'),
                    onPressed: () {
                      if (datePicked1 != null) {
                        // Compare the selected date with the current date and time
                        final currentTime = DateTime.now();
                        if (datePicked1!.isAfter(currentTime)) {
                          // Format the date and time
                          String formattedDate =
                              DateFormat('dd/MM/yy').format(datePicked1!);
                          String formattedTime =
                              DateFormat('HH:mm').format(datePicked2!);

                          // The selected date is in the future, so set the reminder
                          NotificationService().showNotification(
                            title: 'Reminder',
                            body:
                                'Your Reminder has been set for $formattedDate at $formattedTime',
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

              // Save Button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
