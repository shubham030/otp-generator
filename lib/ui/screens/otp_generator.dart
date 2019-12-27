import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otp_generator/ui/bloc/otp_generator_bloc.dart';
import 'package:otp_generator/ui/widgets/build_table.dart';

class OtpGenerator extends StatefulWidget {
  @override
  _OtpGeneratorState createState() => _OtpGeneratorState();
}

class _OtpGeneratorState extends State<OtpGenerator> {
  OtpGeneratorBloc _otpGeneratorBloc = OtpGeneratorBloc();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _otpGeneratorBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              Text(
                'OTP generator',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      //height: 50,
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: StreamBuilder<String>(
                        stream: _otpGeneratorBloc.email,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _controller,
                            onChanged: _otpGeneratorBloc.onEmailChanged,
                            decoration: InputDecoration(
                              errorText: snapshot.error,
                              errorMaxLines: 1,
                              contentPadding: EdgeInsets.all(8),
                              hintText: ' Email Address',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: _otpGeneratorBloc.buttonStatus,
                      builder: (context, snapshot) {
                        bool enable = snapshot.data ?? false;
                        return Container(
                          height: 48,
                          child: OutlineButton(
                            child: Text('OTP'),
                            borderSide: BorderSide(color: Colors.green),
                            textColor: Colors.green,
                            highlightColor: Colors.green,
                            disabledBorderColor: Colors.grey,
                            disabledTextColor: Colors.grey,
                            focusColor: Colors.grey,
                            highlightedBorderColor: Colors.green,
                            onPressed: enable
                                ? () {
                                    if (!_otpGeneratorBloc.emailCheck()) {
                                      _controller.text = '';
                                      _otpGeneratorBloc.generateOtp();
                                    }
                                    // _otpGeneratorBloc.onEmailChanged('');
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: _otpGeneratorBloc.otp,
                      builder: (context, snapshot) {
                        return Container(
                          height: 48,
                          child: Center(
                            child: Text(
                              snapshot.data == null
                                  ? '    '
                                  : snapshot.data.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('otp')
                      .orderBy('timeStamp')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading...');
                      default:
                        _otpGeneratorBloc.otpTime.clear();
                        _otpGeneratorBloc.existingEmail.clear();
                        return BuildTable(
                          snapshot: snapshot,
                          otpGeneratorBloc: _otpGeneratorBloc,
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
