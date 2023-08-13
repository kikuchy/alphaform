import 'package:alphaform/src/validation.dart';

abstract class FormModel extends HasValid{
  Iterable<HasValid> get fields;
  @override
  bool get isValid => fields.every((element) => element.isValid);
}
