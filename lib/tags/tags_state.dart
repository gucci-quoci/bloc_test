part of 'tags_bloc.dart';

abstract class TagsState extends Equatable {
  const TagsState();

  @override
  List<Object> get props => [];
}

class TagsLoadInProgress extends TagsState {
  const TagsLoadInProgress();
}

class TagsLoadOnSuccess extends TagsState {
  final List<Tag> previous;
  final List<Tag> current;

  const TagsLoadOnSuccess(this.previous, this.current);

  @override
  List<Object> get props => [previous, current];
}

class TagsCanceled extends TagsState {
  const TagsCanceled();
}
