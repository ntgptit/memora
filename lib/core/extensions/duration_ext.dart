extension DurationExt on Duration {
  int get totalSeconds => inSeconds;

  String toClockText() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours <= 0) {
      return '$minutes:$seconds';
    }

    return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
  }
}
