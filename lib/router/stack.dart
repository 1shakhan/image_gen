class RouterPagesStack<T> {
  final List<T> _stack;

  RouterPagesStack(this._stack);

  List<T> get pages => _stack;

  int get length => _stack.length;

  T get last => _stack.last;

  void pop() {
    _stack.removeLast();
  }

  void push(T value) {
    _stack.add(value);
  }
}
