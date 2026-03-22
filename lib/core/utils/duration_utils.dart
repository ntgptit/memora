abstract final class DurationUtils {
  static String formatClock(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours <= 0) {
      return '$minutes:$seconds';
    }

    return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
  }
}
