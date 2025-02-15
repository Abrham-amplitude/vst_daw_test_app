enum MidiMessageType { noteOn, noteOff, pitchBend, modulation }

class MidiMessage {
  final MidiMessageType type;
  final int channel;
  final int value1;
  final int value2;

  const MidiMessage({
    required this.type,
    this.channel = 0,
    this.value1 = 0,
    this.value2 = 0,
  });

  // Helper constructors
  factory MidiMessage.noteOn(int note, int velocity, {int channel = 0}) {
    return MidiMessage(
      type: MidiMessageType.noteOn,
      value1: note,
      value2: velocity,
      channel: channel,
    );
  }

  factory MidiMessage.pitchBend(int value, {int channel = 0}) {
    return MidiMessage(
      type: MidiMessageType.pitchBend,
      value1: value,
      channel: channel,
    );
  }

  factory MidiMessage.modulation(int value, {int channel = 0}) {
    return MidiMessage(
      type: MidiMessageType.modulation,
      value1: value,
      channel: channel,
    );
  }
}
