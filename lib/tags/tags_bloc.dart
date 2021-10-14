import 'package:bloc/bloc.dart';
import 'package:bloc_test/tag.dart';
import 'package:equatable/equatable.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc() : super(const TagsLoadInProgress()) {
    on<TagsInitializeEvent>(
      (_, emit) {
        final List<Tag> tags = List.generate(
          10,
          (index) => Tag(
            index.toString(),
          ),
        );
        emit(TagsLoadOnSuccess(tags, tags));
      },
    );
    on<TagsUpdateEvent>(
      (event, emit) {
        if (state is TagsLoadOnSuccess) {
          final TagsLoadOnSuccess tagsLoadOnSuccess =
              state as TagsLoadOnSuccess;
          final List<Tag> tags = List<Tag>.from(tagsLoadOnSuccess.current);

          final Tag tag = event.tag;
          final int indexOfTag = tags.indexOf(tag);

          // Toggle selected
          tags[indexOfTag] = tags[indexOfTag].copyWith(selected: !tag.selected);

          emit(TagsLoadOnSuccess(tagsLoadOnSuccess.previous, tags));
        }
      },
    );
    on<TagsCancelEvent>((_, emit) {
      if (state is TagsLoadOnSuccess) {
        final TagsLoadOnSuccess tagsLoadOnSuccess = state as TagsLoadOnSuccess;
        final List<Tag> previous = tagsLoadOnSuccess.previous;

        // For Navigation.pop()
        emit(const TagsCanceled());

        // Restore previous tags
        emit(TagsLoadOnSuccess(previous, previous));
      }
    });
    on<TagsApplyEvent>((_, emit) {
      if (state is TagsLoadOnSuccess) {
        final TagsLoadOnSuccess tagsLoadOnSuccess = state as TagsLoadOnSuccess;
        final List<Tag> current = tagsLoadOnSuccess.current;

        // For Navigation.pop()
        emit(const TagsCanceled());

        // Apply new tags
        emit(TagsLoadOnSuccess(current, current));
      }
    });
  }
}
