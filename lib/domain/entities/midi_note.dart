class MidiNote {
  final int number;
  
  const MidiNote(this.number);
  
  String get name {
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final octave = (number / 12).floor() - 1;
    final noteIndex = number % 12;
    return '${notes[noteIndex]}$octave';
  }
} 