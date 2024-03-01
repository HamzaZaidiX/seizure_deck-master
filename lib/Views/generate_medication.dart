import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seizure_deck/data/medication_data.dart';

class GenerateMedicationPage extends StatefulWidget {
  @override
  _GenerateMedicationPageState createState() => _GenerateMedicationPageState();
}

class _GenerateMedicationPageState extends State<GenerateMedicationPage> {
  List<Medication> medication = [];

  @override
  void initState() {
    super.initState();
    fetchMedicationData();
  }

  Future<void> fetchMedicationData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://seizuredeck.000webhostapp.com/medication_list.php'));

      if (response.statusCode == 200) {
        List<dynamic> medication = jsonDecode(response.body);
        setState(() {
          medication = List<Medication>.from(medication).cast<Medication>();
        });
      } else {
        throw Exception('Failed to load medication data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Medication List'),
      ),
      body: ListView.builder(
        itemCount: medication.length,
        itemBuilder: (context, index) {
          Medication currentMedication = medication[index];
          return ListTile(
            title: Text(currentMedication.mName),
            subtitle: Text('Dosage: ${currentMedication.dosage}, '
                'Frequency: ${currentMedication.frequency}, '
                'Type: ${currentMedication.mType}'
                'Date: ${currentMedication.datePicked}'
                'Time: ${currentMedication.time}'
                ),
                
          );
        },
      ),
    );
  }
}
