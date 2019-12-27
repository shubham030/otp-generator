import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otp_generator/ui/models/otp_time_info.dart';
import 'package:otp_generator/ui/utils/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class OtpGeneratorBloc with Validator {
  OtpGeneratorBloc() {
    timer = Timer.periodic(Duration(seconds: 1), (e) {
      if (otpTime.isNotEmpty) if (otpTime[0].time.isBefore(DateTime.now())) {
        deleteOtp(otpTime[0].id);
      }
    });
  }

  final _email = BehaviorSubject<String>();
  final _otp = BehaviorSubject<int>();
  Timer timer;

  List<OtpTime> otpTime = [];
  List<String> existingEmail = [];
  Function(String) get onEmailChanged => _email.sink.add;

  Stream<String> get email => _email.stream.transform(emailValidator);
  Stream<int> get otp => _otp.stream;

  Stream<bool> get buttonStatus =>
      CombineLatestStream.combine2(email, email, (e1, e2) => true);

  void generateOtp() {
    var random = Random();
    while (true) {
      int otp = random.nextInt(9999);
      if (otp >= 1000) {
        print(otp);
        _otp.sink.add(otp);
        _pushData();
        break;
      }
    }
  }

  _pushData() {
    Firestore.instance.collection('otp').document().setData({
      'email': _email.value,
      'otp': _otp.value,
      'timeStamp': DateTime.now()
    });
  }

  bool emailCheck() {
    if (existingEmail.isNotEmpty && existingEmail.contains(_email.value)) {
      print('invalid email');
      _email.addError('Email already exists');
      return true;
    }
    return false;
  }

  deleteOtp(String id) {
    Firestore.instance.collection('otp').document(id).delete();
  }

  void dispose() {
    timer.cancel();
    _email.close();
    _otp.close();
  }
}
