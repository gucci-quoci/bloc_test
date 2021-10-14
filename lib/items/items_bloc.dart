import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/item.dart';
import 'package:bloc_test/tags/tags_bloc.dart';
import 'package:equatable/equatable.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final TagsBloc _tagsBloc;
  ItemsBloc(this._tagsBloc) : super(const ItemsLoadInProgress()) {
    on<ItemsInitializeEvent>(
      (_, emit) {
        print('INIT');
        final TagsState tagsState = _tagsBloc.state;
        if (tagsState is TagsLoadOnSuccess) {
          // Generates items with random tags
          final List<Item> items = List.generate(
            20,
            (index) => Item(
              index.toString(),
              List<String>.generate(
                3,
                (_) => Random().nextInt(10).toString(),
              ),
            ),
          );

          // Get tags
          final List<String> tags =
              tagsState.current.map((e) => e.name).toList();

          // Get items witch matching tags
          List<Item> filteredItems;
          if (tags.isEmpty) {
            filteredItems = items;
          } else {
            filteredItems = items
                .where(
                  (element) => element.tags.any(
                    (tag1) => tags.any((tag2) => tag1 == tag2),
                  ),
                )
                .toList();
          }
          emit(ItemsLoadOnSuccess(filteredItems));
        }
      },
    );
  }
}
