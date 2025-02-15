import '../../domain/entities/midi_message.dart';
import '../../domain/repositories/midi_repository.dart';
import 'midi_service.dart';

class MidiServiceImpl implements MidiService {
  final MidiRepository _repository;

  MidiServiceImpl(this._repository);

  @override
  Future<void> sendNote(int note, int velocity, {int channel = 0}) async {
    final message = MidiMessage.noteOn(note, velocity, channel: channel);
    await sendMessage(message);
  }

  @override
  Future<void> sendMessage(MidiMessage message) async {
    await _repository.sendMidiMessage(message);
  }
}
