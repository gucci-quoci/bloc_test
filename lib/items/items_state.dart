part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsLoadInProgress extends ItemsState {
  const ItemsLoadInProgress();
}

class ItemsLoadOnSuccess extends ItemsState {
  const ItemsLoadOnSuccess(this.items);

  final List<Item> items;

  @override
  List<Object> get props => [items];
}
