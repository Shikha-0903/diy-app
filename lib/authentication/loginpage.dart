import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shikha_tycs/authentication/Registration.dart';
import 'package:shikha_tycs/bottom_navigation/Navigation.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late String username="";
  late String password="";
  bool _isPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Email",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent,width: 2.0)
                    )
                  ),

                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 290,
                height: 60,
                child: TextField(
                  cursorColor: Colors.blueAccent,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "Enter Password",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,width: 2.0)
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

                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: ElevatedButton(
                    onPressed:  ()async{
                      try {
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: username,
                            password: password
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      } on FirebaseAuthException catch (e) {
                        //print(e.code);
                        if (e.code == "invalid-credential"){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Incorrect Email or Password'),backgroundColor: Colors.blueAccent,),
                          );
                        }
                        /*if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No user found for that email.')),
                          );
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Wrong password provided')),
                          );
                        }*/
                        else if (e.code == 'channel-error') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter both email and password'),backgroundColor: Colors.blueAccent,),
                          );
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(' ${e.message}')),
                          );
                        }
                      }
                      catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: Text("Login",style: TextStyle(color: Colors.blueAccent),),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                child: TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Register()));
                  },
                  child: Text("Don't Have an Account? Register",style: TextStyle(color: Colors.blueAccent),),
                ),
                ),
              ),
            ],
          ),
        ),
      ),
          backgroundColor: Color(0xFFffffff),
    );
  }
}
