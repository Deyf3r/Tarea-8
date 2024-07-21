import 'package:flutter/material.dart';
import '../models/incident.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/tau.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Incident incident;

  IncidentDetailScreen(this.incident);

  @override
  _IncidentDetailScreenState createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  FlutterSoundPlayer? _audioPlayer;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _audioPlayer!.openPlayer();
    setState(() {
      _isPlayerInitialized = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer!.closePlayer();
    _audioPlayer = null;
    super.dispose();
  }

  void _playAudio() async {
    if (_isPlayerInitialized && widget.incident.audioPath.isNotEmpty) {
      await _audioPlayer!.startPlayer(
        fromURI: widget.incident.audioPath,
        codec: Codec.aacADTS,
      );
    }
  }

  void _stopAudio() async {
    if (_isPlayerInitialized) {
      await _audioPlayer!.stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.incident.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${widget.incident.date.toString()}'),
            SizedBox(height: 10),
            Text('Descripción: ${widget.incident.description}'),
            SizedBox(height: 10),
            if (widget.incident.photoPath.isNotEmpty)
              Image.file(
                File(widget.incident.photoPath),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            if (widget.incident.audioPath.isNotEmpty)
              ElevatedButton(
                onPressed: _playAudio,
                child: Text('Reproducir Audio'),
              ),
          ],
        ),
      ),
    );
  }
}
