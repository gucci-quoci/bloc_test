part of 'tags_bloc.dart';

abstract class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  List<Object?> get props => [];
}

class TagsInitializeEvent extends TagsEvent {
  const TagsInitializeEvent();
}

class TagsUpdateEvent extends TagsEvent {
  final Tag tag;

  const TagsUpdateEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

class TagsCancelEvent extends TagsEvent {
  const TagsCancelEvent();
}

class TagsApplyEvent extends TagsEvent {
  const TagsApplyEvent();
}
