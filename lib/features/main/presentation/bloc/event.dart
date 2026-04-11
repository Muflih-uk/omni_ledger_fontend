abstract class NavigationEvent {}

class MainChangeTabEvent extends NavigationEvent {
  final int index;
  MainChangeTabEvent(this.index);
}
