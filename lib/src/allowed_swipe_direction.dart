/// Class to define the direction in which the card can be swiped
class AllowedSwipeDirection {
  /// Set to true to allow the card to be swiped in the up direction
  final bool up;

  /// Set to true to allow the card to be swiped in the down direction
  final bool down;

  /// Set to true to allow the card to be swiped in the left direction
  final bool left;

  /// Set to true to allow the card to be swiped in the right direction
  final bool right;

  /// Define the direction in which the card can be swiped
  const AllowedSwipeDirection._({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
  });

  /// Allow the card to be swiped in any direction
  const AllowedSwipeDirection.all()
      : up = true,
        down = true,
        right = true,
        left = true;

  /// Does not allow the card to be swiped in any direction
  const AllowedSwipeDirection.none()
      : up = false,
        down = false,
        right = false,
        left = false;

  /// Allow the card to be swiped in only the specified directions
  factory AllowedSwipeDirection.only({
    up = false,
    down = false,
    left = false,
    right = false,
  }) =>
      AllowedSwipeDirection._(
        up: up,
        down: down,
        left: left,
        right: right,
      );

  /// Allow the card to be swiped symmetrically in horizontal or vertical directions
  factory AllowedSwipeDirection.symmetric({
    horizontal = false,
    vertical = false,
  }) =>
      AllowedSwipeDirection._(
        up: vertical,
        down: vertical,
        right: horizontal,
        left: horizontal,
      );
}
