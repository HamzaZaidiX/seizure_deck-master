import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views/medication_reminder.dart';
import 'package:seizure_deck/data/medication_data.dart';
import '../providers/user_provider.dart';
import '../providers/medication_provider.dart';

class medicationHomePage extends StatefulWidget {
  @override
  _medicationHomePageState createState() => _medicationHomePageState();
}

class _medicationHomePageState extends State<medicationHomePage> {
    List<Medication> medication = [];

@override
void initState() {
  super.initState();
  fetchData(); // Call a method to fetch data
}

void fetchData() async {
  try {
    // Fetch data from API or database
    List<Medication> fetchedData = await fetchMedicationData();

    // Update MedicationProvider with fetched data
    Provider.of<MedicationProvider>(context, listen: false).setMedications(fetchedData);
  } catch (e) {
    print('Error fetching data: $e');
  }
}

Future<List<Medication>> fetchMedicationData() async {
  try {
    // Perform asynchronous operation to fetch data
    final response = await http.get(Uri.parse('https://seizuredeck.000webhostapp.com/medication_list.php'));
    // Parse response and extract medication data
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Medication> medication = jsonData.map((medication) => Medication.fromJson(medication)).toList();
      return medication;
    } else {
      throw Exception('Failed to fetch medication data');
    }
  } catch (e) {
    print('Error fetching medication data: $e');
    // Handle the error by returning an empty list or rethrowing the exception
    return []; // or throw e;
  }
}

@override
Widget build(BuildContext context) {
  // Wrap your widget tree with MedicationProvider
  return ChangeNotifierProvider(
    create: (context) => MedicationProvider(), // Create MedicationProvider instance
    child: Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/LOGO.png',
              height: 175,
            ),
            Text(
              'Press + to add a Reminder!',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 81, 81, 82),
              ),
            ),
            
            Consumer<MedicationProvider>(
              builder: (context, medicationProvider, _) {
                List<Medication> medications = medicationProvider.medication;
                          print('Medication Data: $medications');
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        Medication medication = medications[index];
                        return ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          onTap: () {
                            // Handle the tap on the medication if needed
                          },
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          isThreeLine: true,
                          dense: false,
                          title: Text(
                            medications[index].mName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medications[index].mType,
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                medications[index].frequency,
                                style: TextStyle(color: Colors.purple),
                              ),
                              Text(
                                '${medications[index].dosage}',
                                style: TextStyle(color: Colors.purple),
                              ),
                              Text(
                                '${medications[index].datePicked}',
                                style: TextStyle(color: Colors.purple),
                              ),
                              Text(
                                '${medications[index].time}',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const medicationReminder()),
          );
        },
        child: Icon(Icons.add),
      ),
    ),
  );
}
}
