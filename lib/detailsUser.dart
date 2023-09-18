import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lab4/main.dart';
import 'Validate/validate.dart';

class ViewDetal extends State<Detal> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String errname = "", erremail = "", errtel = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telcontroller = TextEditingController();

  Future<void> showDelete(BuildContext context) {
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thông báo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bạn có chắc chắn muốn xóa nhân viên ?"),
                Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: .5, color: Colors.black)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("ID:"),
                          Text("${widget.data["id"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Tên:"),
                          Text(_nameController.text),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Email:"),
                          Text(_emailController.text),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Tel:"),
                          Text(_telcontroller.text),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cansel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Kurale"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    ElevatedButton(
                        onPressed: () {
                          deleteItem();
                          CoolAlert.show(
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            context: context,
                            type: CoolAlertType.success,
                            text: "Xóa nhân viên thành công !",
                          );
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Kurale"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))))
                  ],
                )
              ],
            ),
          );
        });
  }
  Future<void> showUpdate(BuildContext context) {
    EasyLoading.dismiss();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thông báo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bạn có chắc chắn muốn cập nhật nhân viên ?"),
                Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: .5, color: Colors.black)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("ID:"),
                          Text("${widget.data["id"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Tên:"),
                          Text(_nameController.text),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Email:"),
                          Text(_emailController.text),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Tel:"),
                          Text(_telcontroller.text),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cansel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Kurale"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    ElevatedButton(
                        onPressed: () {
                          Update();
                          CoolAlert.show(
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            loopAnimation: true,
                            context: context,
                            type: CoolAlertType.success,
                            text: "Cập nhật viên thành công !",
                          );
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Kurale"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))))
                  ],
                )
              ],
            ),
          );
        });
  }
  Future<void> Update() async {
    final updateNv = {
      "id": widget.data["id"],
      "username": _nameController.text,
      "email": _emailController.text,
      "tel": _telcontroller.text,
    };
    firestore.collection("staff").doc(widget.keyId).update(updateNv);
  }
  void _validateName() {
    setState(() {
      errname = validateName(_nameController.text);
    });
  }
  void _validateEmail() {
    setState(() {
      erremail = validateEmail(_emailController.text);
    });
  }
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data["username"];
    _emailController.text = widget.data["email"];
    _telcontroller.text = widget.data["tel"];
  }

  void _validateTel() {
    setState(() {
      errtel = validateTel(_telcontroller.text);
    });
  }

  void onUpdate() {
    setState(() {
      _validateName();
      if (errname.isEmpty) {
        _validateEmail();
        if (erremail.isEmpty) {
          _validateTel();
          if (errtel.isEmpty) {
            EasyLoading.show(status: "loading...");
            showUpdate(context);
          }
        }
      }
    });
  }

  Future<void> deleteItem() async {
    await firestore.collection("staff").doc(widget.keyId).delete();
  }

  void handleTimeout() {
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), handleTimeout);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chi tiết nhân viên"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ID",
                  style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                ),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "${widget.data["id"]}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Tên nhân viên ",
                  style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      errorText: errname.isNotEmpty ? errname : null,
                      hintText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Email ",
                  style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      errorText: erremail.isNotEmpty ? erremail : null,
                      hintText: "Email address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Tel ",
                  style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _telcontroller,
                  decoration: InputDecoration(
                      errorText: errtel.isNotEmpty ? errtel : null,
                      hintText: "Tel",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onUpdate();
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        EasyLoading.show(status: "loading...");
                        showDelete(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 18, fontFamily: "Kurale"),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
