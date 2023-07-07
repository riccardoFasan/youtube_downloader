class DownloadResult {
  int size;
  Stream<List<int>> stream;

  DownloadResult({
    required this.size,
    required this.stream,
  });
}
