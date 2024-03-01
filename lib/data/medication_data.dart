import 'dart:ffi';

class Medication {
  final int mid;
  final String mName;
  final String mType;
  final double dosage;
  final String frequency;
  final int time;
  final DateTime datePicked;
  final int uid;

  Medication({
    required this.mid,
    required this.mName,
    required this.mType,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.datePicked,
    required this.uid,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      mid: int.parse(json['mid']),
      mName: json['mName'],
      mType: json['mType'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      time: int.parse(json['time']),
      datePicked: DateTime.parse(json['datePicked']),
      uid: int.parse(json['uid']),
    );
  }
}

// // Declare medication variables
// int mid = 0; // Medication ID
// String mName = ''; // Medication Name
// String mType = ''; // Medication mType
// double dosage = double as double; // Medication Dosage
// String frequency = ''; // Medication Frequency
// int time = 0; // Medication Time
// DateTime datePicked = DateTime.now(); // Medication Date
// int uid = 0; // User ID (if applicable)

class MedicationList {
  final List<Medication> medications;

  MedicationList({required this.medications});

  factory MedicationList.fromJson(List<dynamic> json) {
    return MedicationList(
      medications: json.map((medicationJson) => Medication.fromJson(medicationJson)).toList(),
    );
  }
}