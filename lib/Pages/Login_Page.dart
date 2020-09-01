import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_with_firebase/Animation/FadeAnimation.dart';

import 'HomePage.dart';

class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if(user != null){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => HomeScreen(user: user,)
            ));
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Get the Code?\nCode expired within 60s"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async{
                        final code = _codeController.text.trim();
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                        AuthResult result = await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if(user != null){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomeScreen(user: user,)
                          ));
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SingleChildScrollView(
          child:
          Container(
            padding: EdgeInsets.only(top: 100,left: 30,right: 30),
            child: Form(
              child:
                  FadeAnimation(1.5,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text("Login with phone number", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),)),

                  SizedBox(height: 16,),

                  FadeAnimation(
                      1.5,
                      TextFormField(
                        decoration:  InputDecoration(
                          labelText: "Enter Phone number",
                          fillColor: Colors.white,
                          border:  OutlineInputBorder(
                            borderRadius:  BorderRadius.circular(25.0),
                            borderSide:  BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style:  TextStyle(
                          fontFamily: "Poppins",
                        ),
                      )),

                  SizedBox(height: 16,),

                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("LOGIN"),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        final phone = _phoneController.text.trim();

                        loginUser(phone, context);

                      },
                      color: Colors.blue,
                    ),
                  )
                ],
              ),)
            ),
          ),
        )
    );
  }
}