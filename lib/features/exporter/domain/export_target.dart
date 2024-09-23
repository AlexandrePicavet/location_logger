enum ExportTarget {
  exifTool("ExifTool Geotag"),
  database("SQLite Database export");

  final String label;

  const ExportTarget(this.label);

  @override
  String toString() => label;
}
