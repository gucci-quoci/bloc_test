import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String name;
  final List<String> tags;

  const Item(this.name, this.tags);

  @override
  List<Object?> get props => [name, tags];
}
