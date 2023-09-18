import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lab4/homeSceen.dart';
import 'package:lab4/login.dart';
import 'package:provider/provider.dart';
import 'detailsUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FirestoreProvider(),
      child: MyApp(),
    ),
  );
  configLoading();
}

class FirestoreProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data => _data;

  Future<void> fetchData() async {
    try {
      final querySnapshot =
          await _firestore.collection('staff').orderBy('id').get();
      _data = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final String key = doc.id;
        return {"key": key, "data": data};
      }).toList();
      notifyListeners();
    } catch (e) {
      print('No data');
    }
  }
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 3000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Login(),
        resizeToAvoidBottomInset: false,
      ),
      builder: EasyLoading.init(),
    );
  }
}

class ViewApp extends StatefulWidget {
  static final GlobalKey<Home> homeKey = GlobalKey<Home>();
  Home createState() => Home();
}

class Login extends StatefulWidget {
  ViewLogin createState() => ViewLogin();
}

class Detal extends StatefulWidget {
  ViewDetal createState() => ViewDetal();
  final Map<String, dynamic> data;
  final String keyId;
  Detal({required this.data,required this.keyId});
}
