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
  late final MidiService _midiService;
  int _midiNote = 60; // Middle C
  int _velocity = 127;
  int _channel = 0;
  int _pitchBend = 8192; // Center position (0-16383)
  int _modulation = 0; // 0-127

  @override
  void initState() {
    super.initState();
    final repository = MidiRepositoryImpl();
    _midiService = MidiServiceImpl(repository);
  }

  void _sendMidiSignal() async {
    await _midiService.sendNote(_midiNote, _velocity, channel: _channel);
    setState(() {
      _midiNote = (_midiNote + 1) % 128;
    });
  }

  void _updatePitchBend(double value) {
    setState(() {
      _pitchBend = value.round();
    });
    _midiService
        .sendMessage(MidiMessage.pitchBend(_pitchBend, channel: _channel));
  }

  void _updateModulation(double value) {
    setState(() {
      _modulation = value.round();
    });
    _midiService
        .sendMessage(MidiMessage.modulation(_modulation, channel: _channel));
  }

  @override
  Widget build(BuildContext context) {
    final midiNote = MidiNote(_midiNote);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('VST Plugin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current MIDI Note:'),
            Text(
              '${midiNote.name} ($_midiNote)',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Text('Pitch Bend: $_pitchBend'),
            Slider(
              value: _pitchBend.toDouble(),
              min: 0,
              max: 16383,
              onChanged: _updatePitchBend,
            ),
            const SizedBox(height: 20),
            Text('Modulation: $_modulation'),
            Slider(
              value: _modulation.toDouble(),
              min: 0,
              max: 127,
              onChanged: _updateModulation,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMidiSignal,
        tooltip: 'Send MIDI Signal',
        child: const Icon(Icons.music_note),
      ),
    );
  }
}
