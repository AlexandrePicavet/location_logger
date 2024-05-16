enum ExportTarget {
  exifTool("ExifTool Geotag");

  final String label;

  const ExportTarget(this.label);

  @override
  String toString() => label;
}
