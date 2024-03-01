import 'package:flutter/material.dart';
import '../data/medication_data.dart';

class MedicationProvider extends ChangeNotifier {
  List<Medication> _medications = [];

  List<Medication> get medication => _medications;

  void setMedications(List<Medication> medications) {
    _medications = medications;
    notifyListeners();
  }

  addMedication(Medication medication) {}
}
