import '../entities/midi_message.dart';

abstract class MidiRepository {
  Future<void> sendMidiMessage(MidiMessage message);
} 