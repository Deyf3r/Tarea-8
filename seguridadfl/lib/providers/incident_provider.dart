import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incident.dart';

class IncidentProvider with ChangeNotifier {
  List<Incident> _incidents = [];

  List<Incident> get incidents => _incidents;

  Future<void> addIncident(Incident incident) async {
    final db = await _openDatabase();
    await db.insert('incidents', {
      'title': incident.title,
      'date': incident.date.toIso8601String(),
      'description': incident.description,
      'photoPath': incident.photoPath,
      'audioPath': incident.audioPath,
    });
    _incidents.add(incident);
    notifyListeners();
  }

  Future<void> fetchIncidents() async {
    final db = await _openDatabase();
    final data = await db.query('incidents');
    _incidents = data.map((item) => Incident(
      title: item['title'] as String,
      date: DateTime.parse(item['date'] as String),
      description: item['description'] as String,
      photoPath: item['photoPath'] as String,
      audioPath: item['audioPath'] as String,
    )).toList();
    notifyListeners();
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'incidents.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE incidents(id INTEGER PRIMARY KEY, title TEXT, date TEXT, description TEXT, photoPath TEXT, audioPath TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> deleteAllIncidents() async {
    final db = await _openDatabase();
    await db.delete('incidents');
    _incidents = [];
    notifyListeners();
  }
}
