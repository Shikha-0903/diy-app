import 'package:flutter/material.dart';
import 'package:shikha_tycs/authentication/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String name = '';
  bool _isPasswordVisible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage("images/login.jpg")),
              Container(
                width: 290,
                height: 60,
                child: TextField(
                  cursorColor: Colors.blueAccent,
                  controller: _name,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Name",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 290,
                height: 60,
                child: TextField(
                  cursorColor: Colors.blueAccent,
                  controller: _email,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Email",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 290,
                height: 60,
                child: TextField(
                  cursorColor: Colors.blueAccent,
                  controller: _password,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Password",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User registered successfully')),
                            );
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              FirebaseFirestore.instance.collection("user").doc(user.uid).set({
                                "name":_name.text,
                                "password": _password.text,
                                "username": _email.text,
                              });
                            } else {
                              print("User is not logged in");
                            }
                            _email.clear();
                            _password.clear();
                            _name.clear();
                          } on FirebaseAuthException catch (e) {
                            //print(e.code);
                            String errorMessage;
                            switch(e.code){
                              case 'weak-password':
                                errorMessage="Password provided is too weak";
                                break;
                              case 'email-already-in-use':
                                errorMessage="Account already exists";
                                break;
                              case 'invalid-email':
                                errorMessage="Email address is badly formatted";
                                break;
                              case 'channel-error':
                                errorMessage="Please enter all information";
                                break;
                              default:
                                errorMessage='Error:${e.message}';
                                break;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage),backgroundColor: Colors.blueAccent,),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 80),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                        },
                        child: Text(
                          "Go to Login",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFffffff),
    );
  }
}
