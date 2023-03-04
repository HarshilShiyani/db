import 'package:flutter/material.dart';
import 'package:sqflitecrud/database/database.dart';
import 'package:sqflitecrud/model/citymodel.dart';

class AddUser extends StatefulWidget {
  AddUser(this.map, {super.key});

  Map<String, Object?>? map;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late CityModel _ddSelectedValue;
  bool isCitySelected = true;

  void initState() {
    super.initState();
    firstNameController.text =
        widget.map == null ? "" : widget.map!['UserName'].toString();
    dateController.text =
        widget.map == null ? "" : widget.map!['Dob'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Add User",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length == 0) {
                              return 'Enter First Name';
                            }
                            return null;
                          },
                          controller: firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter First Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length == 0) {
                              return 'Enter Date';
                            }
                            return null;
                          },
                          controller: dateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter DOB",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select City",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            FutureBuilder<List<CityModel>>(
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (isCitySelected) {
                                    _ddSelectedValue = snapshot.data![0];
                                    isCitySelected = false;
                                  }
                                  return DropdownButton(
                                    value: _ddSelectedValue,
                                    items: snapshot.data!.map(
                                      (CityModel e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e.Name.toString(),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _ddSelectedValue = value!;
                                      });
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                              future: isCitySelected
                                  ? MyDatabase().getCityList()
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(
                        () async {
                          if (_formKey.currentState!.validate()) {
                            if (widget.map == null) {
                              insertUser().then(
                                (value) => Navigator.of(context).pop(true),
                              );
                            } else {
                              updateUser(widget.map!['UserID']).then(
                                (value) => Navigator.of(context).pop(true),
                              );
                            }
                          }
                        },
                      );
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> insertUser() async {
    Map<String, dynamic> map = {};
    map["Name"] = firstNameController.text;
    map["Dob"] = dateController.text;
    map["CityID"] = _ddSelectedValue.CityID!;

    int userID = await MyDatabase().insertUserDetails(map);
    return userID;
  }

  Future<int> updateUser(id) async {
    Map<String, dynamic> map = {};
    map["Name"] = firstNameController.text;
    map["Dob"] = dateController.text;
    map["CityID"] = _ddSelectedValue.CityID!;

    int userID = await MyDatabase().updateUserDetails(map, id);
    return userID;
  }
}
