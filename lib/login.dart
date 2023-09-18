import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lab4/Validate/validate.dart';
import 'main.dart';

class ViewLogin extends State<Login> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final check = GlobalKey<FormState>();
  bool checkeye = true;
  String _errorUser = '';
  String _errorPass = '';

  Future<void> checkLogin() async {
    EasyLoading.show(status: "loading...");
    String username = usernameController.text;
    String password = passwordController.text;
    _firestore
        .collection('user')
        .where('username', isEqualTo: username)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var user = snapshot.docs[0];
        if (user["password"] == password) {
          EasyLoading.dismiss();
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => ViewApp()));
        } else {
          EasyLoading.showError("Tài khoản hoặc mật khẩu không chính xác");
        }
      } else {
        EasyLoading.showError("Tài khoản hoặc mật khẩu không chính xác");
      }
    });
  }
  void _validateUser() {
    setState(() {
      _errorUser = validateUser(usernameController.text);
    });
  }

  void _validatePass() {
    setState(() {
      _errorPass = validatePass(passwordController.text);
    });
  }
  void onLogin (){
    _validateUser();
    if(_errorUser.isEmpty){
      _validatePass();
      if(_errorPass.isEmpty){
        checkLogin();
      }
    }
  }
  void _toggleObscured() {
    setState(() {
      checkeye = !checkeye;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Color(0xf7f1efef),height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,),
        Positioned(right: 0,top:0,child: Image.asset("assets/Vector3.png")),
        Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height / 4,
            child: Center(
                child: Text(
              "Sign-In",
              style: TextStyle(
                  fontSize: 64, fontFamily: "Kurale", color: Colors.white),
            ))),
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.7),
          child: Form(
            key: check,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color(0xffc7c7c7),
                        spreadRadius: -10,
                        blurStyle: BlurStyle.normal,
                        blurRadius: 210,
                        offset: Offset(0, 0))
                  ]),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Username",
                          errorText: _errorUser.isNotEmpty ? _errorUser : null,
                          labelStyle:
                              TextStyle(fontSize: 18, fontFamily: "Kurale"),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.white)))),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color(0xffc7c7c7),
                        spreadRadius: -10,
                        blurStyle: BlurStyle.normal,
                        blurRadius: 210,
                        offset: Offset(0, 0))
                  ]),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: checkeye,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: _toggleObscured,
                          child: checkeye
                              ? Icon(CupertinoIcons.eye_slash)
                              : Icon(CupertinoIcons.eye),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Password",
                        errorText: _errorPass.isNotEmpty ? _errorPass : null,
                        labelStyle:
                            TextStyle(fontSize: 18, fontFamily: "Kurale"),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(width: 0, color: Colors.white))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 30),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Do you forgot your password ?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Kurale",
                          fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          top: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    onLogin();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Kurale"),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Sign-Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Kurale"),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))))
            ],
          ),
        )
      ],
    );
  }
}
