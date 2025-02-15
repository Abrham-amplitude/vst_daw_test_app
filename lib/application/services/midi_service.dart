import '../../domain/entities/midi_message.dart';

abstract class MidiService {
  Future<void> sendNote(int note, int velocity, {int channel = 0});
  Future<void> sendMessage(MidiMessage message);
} 