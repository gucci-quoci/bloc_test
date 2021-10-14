import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String name;
  final bool selected;

  const Tag(
    this.name, {
    this.selected = false,
  });

  Tag copyWith({
    String? name,
    bool? selected,
  }) =>
      Tag(
        name ?? this.name,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [name, selected];
}
