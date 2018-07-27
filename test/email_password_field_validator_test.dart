
import 'package:login_demo/login_page.dart';
import 'package:test/test.dart';

void main() {

  test('empty email returns error string', () {

    var result = EmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('non-empty email returns null', () {

    var result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {

    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {

    var result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}