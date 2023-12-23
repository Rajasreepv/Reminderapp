import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:remindo/notification.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

DateTime dt = DateTime.now();
// TZDateTime now = TZDateTime.now(getLocation('Asia/Kolkata'));
final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(const MyApp());
  checkReminders();
}

void call() {
  Fluttertoast.showToast(msg: "Reminder Noted");
}

String selectedDay = daysOfWeek.first;
List<Map<String, dynamic>> reminders = [];
List<String> list = <String>[
  'Wakeup',
  'Go to Gym',
  'Breakfast',
  'Meetings',
  'Lunch',
  'QuickNap',
  'Go to Library',
  'Dinner',
  'Go to Sleep'
];
const List<String> daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

TimeOfDay _timeofday = TimeOfDay(hour: 8, minute: 30);
String dropdownValue = list.first;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    NotificationWidget.init();
  }

  void showtimepicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeofday = value!;
      });
    });
  }

  addtoList() {
    Map<String, dynamic> newReminder = {
      'day': selectedDay,
      'time': _timeofday,
      "action": dropdownValue
    };

    reminders.add(newReminder);
    print(reminders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 35, 35),
        title: Text(
          "Remindo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Set Your Reminders",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 2),
            child: Column(
              children: [
                Text(
                  "Choose your Task",
                  style: TextStyle(
                      fontFamily: "Pacifico",
                      color: Color.fromRGBO(125, 10, 10, 9),
                      fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonExample()
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(
                  "Set Your Time",
                  style: TextStyle(
                      fontFamily: "Pacifico",
                      color: Color.fromRGBO(125, 10, 10, 9),
                      fontSize: 22),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 65.0, right: 65.0, top: 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showtimepicker();
                        },
                        icon: Icon(
                          Icons.alarm,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(_timeofday.format(context).toString()),
                      SizedBox(
                        width: 5,
                      ),
                      DropdownButton<String>(
                        value: selectedDay,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDay = newValue!;
                          });
                        },
                        items: daysOfWeek
                            .map((day) => DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(125, 10, 10, 9)),
              ),
              onPressed: () {
                Fluttertoast.showToast(msg: "Reminder Noted");
                addtoList();

                // Fluttertoast.showToast(msg: "Reminder Noted");
              },
              child: Text(
                "Remind Me",
                style: TextStyle(color: Colors.white),
              ))
        ],
      )),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  DropdownButtonExample({
    super.key,
  });

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      elevation: 16,
      style: const TextStyle(color: Color.fromARGB(255, 127, 35, 35)),
      underline: Container(
        height: 2,
        color: Color.fromARGB(255, 83, 12, 12),
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}

void checkReminders() {
  Timer.periodic(const Duration(seconds: 10), (timer) {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinute = currentTime.minute;
    print(currentTime);
    reminders.forEach((reminder) {
      TimeOfDay reminderTime = reminder['time'];
      int reminderHour = reminderTime.hour;
      int reminderMinute = reminderTime.minute;

      if (reminder['day'] == daysOfWeek[currentTime.weekday - 1] &&
          currentTime.hour == reminderHour &&
          currentTime.minute == reminderMinute) {
        String action = reminder['action'];

        NotificationWidget.showNotification(
            title: "You have Reminder", body: action);
      }
    });
  });
}
