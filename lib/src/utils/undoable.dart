class Undoable<T> {
  Undoable(this._value, {Undoable<T>? previousValue})
      : _previous = previousValue;

  T _value;
  Undoable<T>? _previous;

  T get state => _value;
  T? get previousState => _previous?.state;

  set state(T newValue) {
    _previous = Undoable(_value, previousValue: _previous);
    _value = newValue;
  }

  void undo() {
    if (_previous != null) {
      _value = _previous!._value;
      _previous = _previous?._previous;
    }
  }
}
