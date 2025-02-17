import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import '../../domain/entities/midi_message.dart';
import '../../domain/repositories/midi_repository.dart';

class MidiRepositoryImpl implements MidiRepository {
  final _midiCommand = MidiCommand();
  bool _isConnected = false;

  MidiRepositoryImpl() {
    _setupMidi();
  }

  Future<void> _setupMidi() async {
    try {
      final devices = await _midiCommand.devices;
      if (devices == null || devices.isEmpty) {
        print('No MIDI devices found');
        return;
      }

      // Print available devices for debugging
      print('Available MIDI devices:');
      for (var device in devices) {
        print('- ${device.name} (${device.id})');
      }

      // First try to find our VST plugin
      var targetDevice = devices.firstWhere(
        (device) => device.name.toLowerCase().contains('vst plugin'),
        orElse: () {
          // Then try to find any virtual MIDI port
          return devices.firstWhere(
            (device) => device.name.toLowerCase().contains('virtual'),
            orElse: () {
              print('No suitable MIDI device found, using first available');
              return devices.first;
            },
          );
        },
      );

      print('Connecting to: ${targetDevice.name}');
      await _midiCommand.connectToDevice(targetDevice);
      _isConnected = true;
      print('Connected successfully');

      // Listen for device connection changes
      _midiCommand.onMidiSetupChanged?.listen((_) {
        print('MIDI setup changed, attempting reconnection...');
        _setupMidi();
      });
    } catch (e) {
      print('Error setting up MIDI: $e');
      _isConnected = false;
    }
  }

  @override
  Future<void> sendMidiMessage(MidiMessage message) async {
    if (!_isConnected) {
      print('Not connected to MIDI device');
      return;
    }

    try {
      late final Uint8List data;

      switch (message.type) {
        case MidiMessageType.noteOn:
          data = Uint8List.fromList([
            0x90 + message.channel,
            message.value1,
            message.value2,
          ]);
          break;
        case MidiMessageType.noteOff:
          data = Uint8List.fromList([
            0x80 + message.channel,
            message.value1,
            message.value2,
          ]);
          break;
        case MidiMessageType.pitchBend:
          data = Uint8List.fromList([
            0xE0 + message.channel,
            message.value1 & 0x7F,
            (message.value1 >> 7) & 0x7F,
          ]);
          break;
        case MidiMessageType.modulation:
          data = Uint8List.fromList([
            0xB0 + message.channel,
            0x01, // CC#1 is modulation
            message.value1,
          ]);
          break;
      }

      _midiCommand.sendData(data);
    } catch (e) {
      print('Error sending MIDI message: $e');
      _isConnected = false;
      rethrow;
    }
  }
}
