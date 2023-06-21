String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  int twoDigitHours = duration.inHours;
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (twoDigitHours == 0) return "$twoDigitMinutes:$twoDigitSeconds";
  return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}
