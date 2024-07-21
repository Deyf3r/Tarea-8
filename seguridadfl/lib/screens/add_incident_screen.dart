import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Importa el paquete
import 'dart:io';
import '../models/incident.dart';
import '../providers/incident_provider.dart';

class AddIncidentScreen extends StatefulWidget {
  @override
  _AddIncidentScreenState createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _selectedDate = DateTime.now();
  String _photoPath = '';
  String _audioPath = '';
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _openAudioSession();
  }

  Future<void> _openAudioSession() async {
    await _audioRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _photoPath = pickedImage.path;
      });
    }
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      final directory = await getApplicationDocumentsDirectory();
      _audioPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder!.startRecorder(toFile: _audioPath, codec: Codec.aacADTS);
      setState(() {
        _isRecording = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No tienes permisos para grabar audio.'),
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newIncident = Incident(
        title: _title,
        date: _selectedDate,
        description: _description,
        photoPath: _photoPath,
        audioPath: _audioPath,
      );
      Provider.of<IncidentProvider>(context, listen: false).addIncident(newIncident);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Incidencia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text('Tomar Foto'),
                    onPressed: _pickImage,
                  ),
                  if (_photoPath.isNotEmpty)
                    Image.file(
                      File(_photoPath),
                      width: 100,
                      height: 100,
                    ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    label: Text(_isRecording ? 'Detener Grabación' : 'Grabar Audio'),
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Guardar Incidencia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
