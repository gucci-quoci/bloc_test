part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ItemsInitializeEvent extends ItemsEvent {
  const ItemsInitializeEvent();
}
