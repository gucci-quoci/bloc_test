import 'package:bloc_test/item.dart';
import 'package:bloc_test/items/items_bloc.dart';
import 'package:bloc_test/tag.dart';
import 'package:bloc_test/tags/tags_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<TagsBloc>(
        create: (context) => TagsBloc()..add(const TagsInitializeEvent()),
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: const [
              FilterButton(),
              ItemList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsBloc, TagsState>(
      builder: (context, state) {
        if (state is TagsLoadInProgress) {
          return const LoadingIndicator();
        } else if (state is TagsLoadOnSuccess) {
          print('REBUILD 1');
          return BlocProvider<ItemsBloc>(
            create: (context) => ItemsBloc(context.read<TagsBloc>())
              ..add(const ItemsInitializeEvent()),
            child: BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                print('REBUILD 2');
                if (state is ItemsLoadInProgress) {
                  return const LoadingIndicator();
                } else {
                  final List<Item> items = (state as ItemsLoadOnSuccess).items;
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) => Center(
                      child: Text(
                        items[index].toString(),
                      ),
                    ),
                    itemCount: items.length,
                  );
                }
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<TagsBloc>(),
          child: Dialog(
            child: BlocConsumer<TagsBloc, TagsState>(
              listener: (context, state) {
                if (state is TagsCanceled) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is TagsLoadInProgress) {
                  return const LoadingIndicator();
                } else if (state is TagsLoadOnSuccess) {
                  final List<Tag> tags = state.current;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tags.length,
                        itemBuilder: (context, index) {
                          final Tag tag = tags[index];
                          return Row(
                            children: [
                              Checkbox(
                                value: tag.selected,
                                onChanged: (_) => context.read<TagsBloc>().add(
                                      TagsUpdateEvent(tag),
                                    ),
                              ),
                              Text(tag.name),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => context
                                .read<TagsBloc>()
                                .add(const TagsCancelEvent()),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => context
                                .read<TagsBloc>()
                                .add(const TagsApplyEvent()),
                            child: const Text('APPLY'),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
      child: const Text('FILTER'),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
