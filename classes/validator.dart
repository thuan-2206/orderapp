import 'dart:async';

class Validator {
  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains('.')) {
      sink.add(email);
    } else if (email.length > 0) {
      sink.addError('Email không hợp lệ');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(password);
        } else if (password.length > 0) {
          sink.addError('Mật khẩu phải có ít nhất 6 ký tự');
        }
      });
}