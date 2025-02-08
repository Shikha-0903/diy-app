import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shikha_tycs/constants.dart';
import 'package:shikha_tycs/favourite/wishlist.dart';

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace 'user' with the actual collection name in Firestore
    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('user');


    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: usersCollection.doc(userId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found'));
          }

          // Fetch the user data from the snapshot
          Map<String, dynamic> userData =
          snapshot.data!.data() as Map<String, dynamic>;

          String name = userData['name'] ?? 'No name available';
          String username = userData['username'] ?? 'No username available';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red,Colors.lightBlue],begin: Alignment.topLeft,end: Alignment.bottomRight)
                   ),
                  width: double.infinity,
                  height: 300,
                  child: Card(
                    elevation: 10,
                    child: Container(
                      margin: EdgeInsets.only(top:40),
                      child: Column(
                        children: [
                          Icon(Icons.person),
                          Text(
                            'Name : $name',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Username : $username',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20,),
                          IconButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WishlistPage()));
                          }, icon: Icon(Icons.stars_rounded,size: 30,color: Colors.lightBlue,)),
                          Text("Wishlist")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
