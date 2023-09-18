import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lab4/Model/user.dart';
import 'package:lab4/Validate/validate.dart';
import 'package:lab4/main.dart';
import 'package:provider/provider.dart';

class Home extends State<ViewApp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String name = "", email = "", tel = "";

  Future<void> add(User item) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection("staff")
        .orderBy("id", descending: true)
        .get();
    int id;
    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      final customerData = document.data() as Map<String, dynamic>;
      final currentMaxId = customerData['id'] as int;
      id = currentMaxId + 1;
    } else {
      id = 1;
    }
    await _firestore.collection("staff").add({
      "id": id,
      "username": item.name,
      "email": item.email,
      "tel": item.tel,
    });
    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  void Add(){
    showDialog(context: context, builder: (context){
      return DialogAdd(
        onAdd:(User item){
          add(item);
        }
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final getItem = Provider.of<FirestoreProvider>(context);
    getItem.fetchData();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Quản lý nhân viên"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: CustomSearch());
                },
                icon: Icon(CupertinoIcons.search)),
            IconButton(onPressed: () {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  var tween = Tween(begin: const Offset(-1.0,0.0), end: Offset.zero);
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: Login(),
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),);
            }, icon: Icon(Icons.exit_to_app))
          ],
        ),

        body: Stack(
          children: [
            ListView.builder(
              itemCount: getItem.data.length,
              padding: EdgeInsets.only(top: 10),
              itemBuilder: (context, index) {
                final item = getItem.data[index];
                final key = item["key"];
                final itemData = item["data"];
                final name = itemData["username"]; // Truy cập trường name
                final id = itemData["id"];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 1, color: Colors.grey)),
                  child: ListTile(
                    onTap: () {
                      EasyLoading.show(status: "loading...");
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Detal(
                            data: itemData,
                            keyId: key,
                          ),
                        ),
                      );
                    },
                    title: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text("$id")),
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text("Tên nhân viên :")),
                        Text("$name")
                      ],
                    ),
                    trailing: InkWell(
                      child: Icon(Icons.navigate_next),
                    ),
                  ),
                );
              },
            ),
            Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Add();
                  },
                  label: Text("Add"),
                  icon: Icon(Icons.add),
                )),
          ],
        ),
      ),
    );
  }
}
class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = "";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, null);
    }, icon: Icon(CupertinoIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String query) {
    final FirebaseFirestore _usersStream = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream.collection('staff').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        final results =
        snapshot.data!.docs.where((a) => a['username'].contains(query));
        if (results.isEmpty) {
          return Center(child: Text(' Không tìm thấy tên nhân viên thích hợp '));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final user = results.elementAt(index);
            final userData = user.data() as Map<String, dynamic>;
            final docId = user.id;
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                  onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>Detal(keyId: docId,data:userData,))),
                  title: Text(user['username'])),
            );
          }
        );
      }
    );
  }
}

class DialogAdd extends StatefulWidget{
  final Function(User) onAdd;
  DialogAdd({required this.onAdd});
  viewAdd createState()=> viewAdd();
}
class viewAdd extends State<DialogAdd>{
  String errname = "", erremail = "", errtel = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telcontroller = TextEditingController();
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

  void _validateTel() {
    setState(() {
      errtel = validateTel(_telcontroller.text);
    });
  }
  void onAdd() {
    setState(() {
      _validateName();
      if (errname.isEmpty) {
        _validateEmail();
        if (erremail.isEmpty) {
          _validateTel();
          if (errtel.isEmpty) {
            final User user = User(
              id: 0,
              email: _emailController.text,
              name: _nameController.text,
              tel: _telcontroller.text

            );
            EasyLoading.show(status: "loading...");
            widget.onAdd(user);
          }
        }
      }
    });
  }
  Future<void> reset() async {
    _nameController.clear();
    _telcontroller.clear();
    _emailController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thêm nhân viên"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                errorText: errname.isNotEmpty ? errname : null,
                contentPadding:
                EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                labelText: "Tên nhân viên",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                errorText: erremail.isNotEmpty ? erremail : null,
                contentPadding:
                EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                labelText: "Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _telcontroller,
            decoration: InputDecoration(
                helperMaxLines: 14,
                errorText: errtel.isNotEmpty ? errtel : null,
                contentPadding:
                EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                labelText: "Tel",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              ElevatedButton(
                onPressed: () {
                  onAdd();
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ],
          )
        ],
      ),);
  }

}