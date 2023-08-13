typedef Validator<I, R, D, E> = Set<E> Function(I? value, R root, D dependent);

enum Cleanness {
  pristine,
  dirty,
}

abstract class HasValid {
  bool get isValid;
}
