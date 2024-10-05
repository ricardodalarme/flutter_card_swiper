/// Represents the direction of a card swipe using an angle.
///
/// The direction is represented by an angle in degrees, following a clockwise rotation:
/// * 0° points to the top
/// * 90° points to the right
/// * 180° points to the bottom
/// * 270° points to the left
///
/// The class provides standard cardinal directions as static constants:
/// ```dart
/// CardSwiperDirection.top    // 0°
/// CardSwiperDirection.right  // 90°
/// CardSwiperDirection.bottom // 180°
/// CardSwiperDirection.left   // 270°
/// ```
///
/// Custom angles can be created using [CardSwiperDirection.custom]:
/// ```dart
/// final diagonal = CardSwiperDirection.custom(45); // Creates a top-right direction
/// ```
///
/// All angles are normalized to be within the range [0, 360) degrees. When comparing
/// directions, a tolerance of 5 degrees is used by default to account for small variations
/// in swipe gestures.
///
/// The direction also maintains a human-readable name, which is automatically generated
/// based on the angle's quadrant (e.g., 'top-right', 'right-bottom') or can be
/// manually specified when creating a custom direction.
class CardSwiperDirection {
  /// The angle in degrees representing the direction of the swipe
  final double angle;

  /// The name of the direction.
  ///
  /// This is not used in any operations - can be considered as a debug info if you may.
  final String name;

  /// Creates a new [CardSwiperDirection] with the specified angle in degrees
  const CardSwiperDirection._({
    required this.angle,
    required this.name,
  });

  /// No movement direction (Infinity)
  static const none = CardSwiperDirection._(
    angle: double.infinity,
    name: 'none',
  );

  /// Swipe to the top (0 degrees)
  static const top = CardSwiperDirection._(angle: 0, name: 'top');

  /// Swipe to the right (90 degrees)
  static const right = CardSwiperDirection._(angle: 90, name: 'right');

  /// Swipe to the bottom (180 degrees)
  static const bottom = CardSwiperDirection._(angle: 180, name: 'bottom');

  /// Swipe to the left (270 degrees)
  static const left = CardSwiperDirection._(angle: 270, name: 'left');

  /// Creates a custom swipe direction with the specified angle in degrees
  factory CardSwiperDirection.custom(double angle, {String? name}) {
    // Normalize angle to be between 0 and 360 degrees
    final normalizedAngle = (angle % 360 + 360) % 360;
    // Generate a name if not provided
    final directionName = name ?? _getDirectionName(normalizedAngle);
    return CardSwiperDirection._(
      angle: normalizedAngle,
      name: directionName,
    );
  }

  /// Generate a direction name based on the angle
  static String _getDirectionName(double angle) {
    if (angle == 0) return 'top';
    if (angle == 90) return 'right';
    if (angle == 180) return 'bottom';
    if (angle == 270) return 'left';

    // For custom angles, generate a name based on the quadrant
    if (angle > 0 && angle < 90) return 'top-right';
    if (angle > 90 && angle < 180) return 'right-bottom';
    if (angle > 180 && angle < 270) return 'bottom-left';
    return 'left-top';
  }

  /// Checks if this direction is approximately equal to another direction
  /// within a certain tolerance (default is 5 degrees)
  bool isCloseTo(CardSwiperDirection other, {double tolerance = 5}) {
    final diff = (angle - other.angle).abs();
    return diff <= tolerance || (360 - diff) <= tolerance;
  }

  /// Returns true if the direction is horizontal (left or right)
  bool get isHorizontal => isCloseTo(right) || isCloseTo(left);

  /// Returns true if the direction is vertical (top or bottom)
  bool get isVertical => isCloseTo(top) || isCloseTo(bottom);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardSwiperDirection &&
        other.angle == angle &&
        other.name == name;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(angle, name);

  @override
  String toString() => 'CardSwiperDirection($name: $angle°)';
}
