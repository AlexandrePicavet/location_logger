enum Direction {
  asc("ASC"),
  desc("DESC");

  final String repr;

  const Direction(this.repr);

  @override
  String toString() => repr;
}
