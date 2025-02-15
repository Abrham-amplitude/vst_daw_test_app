import 'dart:typed_data';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import '../../domain/entities/midi_message.dart';
import '../../domain/repositories/midi_repository.dart';

class MidiRepositoryImpl implements MidiRepository {
  final _midiCommand = MidiCommand();

  MidiRepositoryImpl() {
    _setupMidi();
  }

  Future<void> _setupMidi() async {
    final devices = await _midiCommand.devices;
    if (devices != null && devices.isNotEmpty) {
      // Look for the JUCE plugin in the devices list
      final juceDevice = devices.firstWhere(
          (device) => device.name.contains('VST Plugin'),
          orElse: () => devices.first);
      await _midiCommand.connectToDevice(juceDevice);
    }
  }

  @override
  Future<void> sendMidiMessage(MidiMessage message) async {
    late final Uint8List data;

    switch (message.type) {
      case MidiMessageType.noteOn:
        data = Uint8List.fromList([
          0x90 + message.channel,
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
      default:
        return;
    }

    _midiCommand.sendData(data);
  }
}
