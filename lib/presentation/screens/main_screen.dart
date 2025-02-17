import 'package:flutter/material.dart';
import '../../application/services/midi_service.dart';
import '../../application/services/midi_service_impl.dart';
import '../../infrastructure/repositories/midi_repository_impl.dart';
import '../../domain/entities/midi_note.dart';
import '../../domain/entities/midi_message.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MidiService _midiService = MidiServiceImpl(MidiRepositoryImpl());
  int _currentNote = 60; // Middle C
  int _velocity = 100;
  int _channel = 0;
  int _pitchBend = 8192; // Center position (0-16383)
  int _modulation = 0; // 0-127

  void _sendMidiSignal() async {
    try {
      // Send Note On
      await _midiService.sendNote(_currentNote, _velocity);
      print('Sent MIDI Note: $_currentNote');

      // Send Note Off after 500ms
      await Future.delayed(const Duration(milliseconds: 500));
      await _midiService.sendMessage(
        MidiMessage.noteOff(_currentNote, _velocity),
      );
    } catch (e) {
      print('Error sending MIDI: $e');
    }
  }

  void _updatePitchBend(double value) {
    setState(() {
      _pitchBend = value.round();
    });
    _midiService.sendMessage(
      MidiMessage.pitchBend(_pitchBend, channel: _channel),
    );
  }

  void _updateModulation(double value) {
    setState(() {
      _modulation = value.round();
    });
    _midiService.sendMessage(
      MidiMessage.modulation(_modulation, channel: _channel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MIDI Controller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current Note: ${MidiNote(_currentNote).name}'),
            Slider(
              value: _currentNote.toDouble(),
              min: 48,
              max: 72,
              divisions: 24,
              label: MidiNote(_currentNote).name,
              onChanged: (value) {
                setState(() => _currentNote = value.round());
              },
            ),
            Text('Velocity: $_velocity'),
            Slider(
              value: _velocity.toDouble(),
              min: 0,
              max: 127,
              divisions: 127,
              onChanged: (value) {
                setState(() {
                  _velocity = value.round();
                });
              },
            ),
            Text('Channel: ${_channel + 1}'),
            Slider(
              value: _channel.toDouble(),
              min: 0,
              max: 15,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  _channel = value.round();
                });
              },
            ),
            Text('Pitch Bend: $_pitchBend'),
            Slider(
              value: _pitchBend.toDouble(),
              min: 0,
              max: 16383,
              onChanged: _updatePitchBend,
            ),
            Text('Modulation: $_modulation'),
            Slider(
              value: _modulation.toDouble(),
              min: 0,
              max: 127,
              onChanged: _updateModulation,
            ),
            ElevatedButton(
              onPressed: _sendMidiSignal,
              child: const Text('Send Note'),
            ),
          ],
        ),
      ),
    );
  }
}
