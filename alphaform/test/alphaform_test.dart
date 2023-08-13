import 'dart:mirrors';

import 'package:alphaform/alphaform.dart';
import 'package:test/test.dart';

class ValidationDependsOn {
  final Type rootType;
  final Symbol fieldPath;
  const ValidationDependsOn(this.path, this.fieldPath);
}

class Case1 {
  @ValidationDependsOn(Case1, #isEmployed)
  final String mail;
  final bool isEmployed;

  const Case1({
    required this.mail,
    required this.isEmployed,
  });
}


class MailCase1FieldPath implements FieldPath<String?, Case1FormModel> {
  const MailCase1FieldPath();
  @override
  String? getValue(Case1FormModel root) {
    return root.mail.value;
  }
}
const mailCase1FieldPath = MailCase1FieldPath();

class IsEmployedCase1FieldPath implements FieldPath<bool?, Case1FormModel> {
  const IsEmployedCase1FieldPath();
  @override
  bool? getValue(Case1FormModel root) {
    return root.isEmployed.value;
  }
}
const isEmployedCase1FieldPath = IsEmployedCase1FieldPath();


class Case1FormModel extends FormModel {
  late MailCase1FieldModel _mail;
  MailCase1FieldModel get mail => _mail;
  late IsEmployedCase1FieldModel _isEmployed;
  IsEmployedCase1FieldModel get isEmployed => _isEmployed;

  @override
  Iterable<HasValid> get fields => [
    mail,
    isEmployed,
  ];

  Case1FormModel._();

  factory Case1FormModel({
    required FieldConfig<String?, Case1FormModel, (IsEmployedCase1FieldPath,), String> mail,
    required FieldConfig<bool?, Case1FormModel, (), String> isEmployed,
  }) {
    final form = Case1FormModel._();
    final mailField = MailCase1FieldModel.pristine(
      value: mail.initialValue,
      validator: mail.validator,
      root: form,
      dependsOn: (isEmployedCase1FieldPath,),
    );
    form._mail = mailField;
    final isEmployedField = IsEmployedCase1FieldModel.pristine(
      value: isEmployed.initialValue,
      validator: isEmployed.validator,
      root: form,
    );
    form._isEmployed = isEmployedField;
    return form;
  }

  Case1FormModel copyWith({
    FieldConfig<String?, Case1FormModel, (IsEmployedCase1FieldPath,), String>? mail,
    FieldConfig<bool?, Case1FormModel, (), String>? isEmployed,
  }) {
    final form = Case1FormModel._();
    final mailField = MailCase1FieldModel._(
      value: mail?.initialValue ?? this.mail.value,
      validator: mail?.validator ?? this.mail.validator,
      root: form,
      dependsOn: (isEmployedCase1FieldPath,),
      cleanness: mail?.cleanness ?? this.mail.cleanness,
    );
    form._mail = mailField;
    final isEmployedField = IsEmployedCase1FieldModel._(
      value: isEmployed?.initialValue ?? this.isEmployed.value,
      validator: isEmployed?.validator ?? this.isEmployed.validator,
      root: form,
      cleanness: isEmployed?.cleanness ?? this.isEmployed.cleanness,
    );
    form._isEmployed = isEmployedField;
    return form;
  }

  Case1FormModel updateMail(String? value, { Cleanness cleanness = Cleanness.dirty }) => copyWith(mail: FieldConfig(initialValue: value, validator: mail.validator, cleanness: cleanness,));
  Case1FormModel updateIsEmployed(bool? value, { Cleanness cleanness = Cleanness.dirty }) => copyWith(isEmployed: FieldConfig(initialValue: value, validator: isEmployed.validator, cleanness: cleanness,));
}

class MailCase1FieldModel implements FieldModel<String?, String, (IsEmployedCase1FieldPath,), Case1FormModel> {
  final Case1FormModel root;
  final (IsEmployedCase1FieldPath,) dependsOn;
  final Validator<String?, Case1FormModel, (IsEmployedCase1FieldPath,), String> validator;
  @override
  final String? value;
  @override
  final Cleanness cleanness;

  MailCase1FieldModel._({
    required this.root,
    required this.dependsOn,
    required this.validator,
    required this.value,
    required this.cleanness,
  });

  MailCase1FieldModel.pristine({
    required this.root,
    required this.dependsOn,
    required this.validator,
    required this.value,
  }) : cleanness = Cleanness.pristine;

  MailCase1FieldModel.dirty({
    required this.root,
    required this.dependsOn,
    required this.validator,
    required this.value,
  }) : cleanness = Cleanness.dirty;

  late final Set<String> _validationResult = validator(value, root, dependsOn);

  @override
  bool get isValid => _validationResult.isEmpty;
  @override
  Set<String> get errors => _validationResult;

  @override
  bool get isDirty => cleanness == Cleanness.dirty;
}

class IsEmployedCase1FieldModel implements FieldModel<bool?, String, (), Case1FormModel> {
  final Case1FormModel root;
  final Validator<bool?, Case1FormModel, (), String> validator;
  @override
  final bool? value;
  @override
  final Cleanness cleanness;

  IsEmployedCase1FieldModel._({
    required this.root,
    required this.validator,
    required this.value,
    required this.cleanness,
  });

  IsEmployedCase1FieldModel.pristine({
    required this.root,
    required this.validator,
    required this.value,
  }) : cleanness = Cleanness.pristine;

  IsEmployedCase1FieldModel.dirty({
    required this.root,
    required this.validator,
    required this.value,
  }) : cleanness = Cleanness.dirty;

  late final Set<String> _validationResult = validator(value, root, ());

  @override
  bool get isValid => _validationResult.isEmpty;
  @override
  Set<String> get errors => _validationResult;

  @override
  bool get isDirty => cleanness == Cleanness.dirty;
}


void main() {
  group('Case1', () {
    Set<String> mailValidator(String? value, Case1FormModel root, (IsEmployedCase1FieldPath,) dependsOn) {
      if (value == null || value.isEmpty) {
        return {"メールアドレスを入力してください"};
      }
      if (!value.contains("@")) {
        return {"メールアドレスの形式が不正です"};
      }
      final isEmployed = dependsOn.$1.getValue(root) ?? false;
      if (isEmployed && !value.endsWith("@example.com")) {
        return {"社員の場合は@example.comで終わるメールアドレスを入力してください"};
      }
      return {};
    }

    Set<String> isEmployedValidator(bool? value, Case1FormModel root, () dependsOn) {
      if (value == null) {
        return {"社員かどうかを入力してください"};
      }
      return {};
    }

    setUp(() {
      // Additional setup goes here.
    });

    test("初期値無し初期化", () {
      final form = Case1FormModel(
        mail: FieldConfig(initialValue: null, validator: mailValidator),
        isEmployed: FieldConfig(initialValue: null, validator: isEmployedValidator),
      );
      expect(form.mail.isValid, isFalse);
      expect(form.mail.isDirty, isFalse);
      expect(form.mail.errors, isNotEmpty);
      expect(form.mail.value, isNull);
      expect(form.isEmployed.isValid, isFalse);
      expect(form.isEmployed.isDirty, isFalse);
      expect(form.isEmployed.errors, isNotEmpty);
      expect(form.isEmployed.value, isNull);
    });

    test("初期値あり初期化（isEmployedがfalseのとき）", () {
      final form = Case1FormModel(
        mail: FieldConfig(initialValue: "hoge@hoge.com", validator: mailValidator),
        isEmployed: FieldConfig(initialValue: false, validator: isEmployedValidator),
      );
      expect(form.mail.isValid, isTrue);
      expect(form.mail.isDirty, isFalse);
      expect(form.mail.errors, isEmpty);
      expect(form.mail.value, "hoge@hoge.com");
      expect(form.isEmployed.isValid, isTrue);
      expect(form.isEmployed.isDirty, isFalse);
      expect(form.isEmployed.errors, isEmpty);
      expect(form.isEmployed.value, false);
    });

    test("初期値あり初期化（isEmployedがtrueのとき）", () {
      final form = Case1FormModel(
        mail: FieldConfig(initialValue: "hoge@hoge.com", validator: mailValidator),
        isEmployed: FieldConfig(initialValue: true, validator: isEmployedValidator),
      );
      expect(form.mail.isValid, isFalse);
      expect(form.mail.isDirty, isFalse);
      expect(form.mail.errors, isNotEmpty);
      expect(form.mail.value, "hoge@hoge.com");
      expect(form.isEmployed.isValid, isTrue);
      expect(form.isEmployed.isDirty, isFalse);
      expect(form.isEmployed.errors, isEmpty);
      expect(form.isEmployed.value, true);
    });

    test("初期値無し初期化 => invalidな更新", () {
      final init = Case1FormModel(
        mail: FieldConfig(initialValue: null, validator: mailValidator),
        isEmployed: FieldConfig(initialValue: null, validator: isEmployedValidator),
      );
      final form = init.updateMail("hogehoge");
      expect(form.mail.isValid, isFalse);
      expect(form.mail.isDirty, isTrue);
      expect(form.mail.errors, isNotEmpty);
      expect(form.mail.value, "hogehoge");
      expect(form.isEmployed.isValid, isFalse);
      expect(form.isEmployed.isDirty, isFalse);
      expect(form.isEmployed.errors, isNotEmpty);
      expect(form.isEmployed.value, isNull);
    });
  });
}
