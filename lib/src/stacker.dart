class Stacker<T> {
  final List<T> _stack = [];
  final List<T> _backStack = [];
  final bool isInfinite;

  Stacker({List<T> initial = const [], this.isInfinite = false}) {
    _stack.addAll(initial);
  }

  void push(T item) {
    _stack.add(item);
  }

  void pop() {
    final removedItem = _stack.removeLast();
    _backStack.add(removedItem);

    if (_stack.isEmpty && isInfinite) {
      _stack.addAll(_backStack.reversed);
    }
  }

  void back() {
    final returnedItem = _backStack.removeLast();
    _stack.add(returnedItem);
  }

  int get currentIndex => _stack.length - 1;

  T get current => _stack[currentIndex];

  T get next => isInfinite && _stack.length == 1
      ? _backStack.first
      : _stack[_stack.length - 2];

  bool get hasFront => _stack.isNotEmpty;

  bool get hasBack2 => _backStack.isNotEmpty;

  bool get hasBack => _stack.length > 1 || isInfinite && _backStack.isNotEmpty;

  bool get isLast => _stack.length == 1;
}
