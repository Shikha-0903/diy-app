import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shikha_tycs/video/festival_videos.dart';
class Festival extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Festivals',style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Festival').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.lightBlue,));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No festivals found'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;

              String imageUrl = data['imageUrl'] ?? "";
              String festivalName = data['name'] ?? 'Festival';
              List<String> craftKeywords = List<String>.from(data['craftKeywords'] ?? []);
              String t1 =data['t1'];
              String t2 =data["t2"];
              String t3 =data["t3"];
              String d1 =data["d1"];
              String d2 =data["d2"];
              String d3 =data["d3"];


              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomVideoPlayer(
                        query: festivalName,
                        craftKeywords: craftKeywords,
                        t1: t1,
                        t2: t2,
                        t3: t3,
                        d1: d1,
                        d2: d2,
                        d3: d3,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(festivalName,style: TextStyle(fontFamily: "NotoSerif"),),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

