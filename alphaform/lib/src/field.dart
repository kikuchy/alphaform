import 'package:alphaform/src/validation.dart';

class FieldConfig<INPUTVALUE, ROOT, DEPENDENT, ERRORTYPE> {
  final INPUTVALUE initialValue;
  final Validator<INPUTVALUE, ROOT, DEPENDENT, ERRORTYPE> validator;
  final Cleanness cleanness;

  const FieldConfig({
    required this.initialValue,
    required this.validator,
    this.cleanness = Cleanness.pristine,
  });
}

abstract class FieldPath<T, R> {
  T getValue(R root);
}

abstract class FieldModel<INPUTVALUE, ERRORTYPE, DEPENDENT, ROOT> implements HasValid {
  INPUTVALUE? get value;
  Cleanness get cleanness;
  @override
  bool get isValid;
  bool get isDirty;
  Set<ERRORTYPE> get errors;
}
