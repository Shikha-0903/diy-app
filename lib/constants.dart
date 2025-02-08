import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

final api_key = dotenv.env['API_KEY'];
final String userId = FirebaseAuth.instance.currentUser!.uid;

const List<String> channelIds = [
  "UCrtZQN1I-7efLhrhSVFCGgQ",
  "UCLfXSqSiuBoJW36oc79mOBg",
  "UC97YujK1RBZgch-oxgEsmSw",
  "UC_ViiQBrIqBK6Jd2fs8UU2w",
  "UCpeVNjWZoI3F_UcqHpPFKlg",
  "UC1m_wJF-qJ_VnPQKNahOmjQ",
  "UCx_Lq20lGkRFNDujj-G6sOg",
  "UC3tWyK-inr5chhRz7BGoOLQ",
  "UC8D2I8W8DWL0dsesrAPURwA",
  "UCA052_DVhbTV4mH5YZY8A4A",
  "UCMmDHoguCpHoW3JagA1xtZg",
  "UCaXCIohGTRQ1z_SIAEBjqYg",
  "UCgb943i9GnEnb0WzoAYja0Q",
  "UCr8knzz5ua7wvmW-QHyzoIQ",
  "UCIOgvkrVt5YZEcVnbA2qVtQ",
  "UCUqbdDXtgI5Kyhm-HaMs9hQ",
  "UCTyq65bAb8yu0JSBPkQ4U0g",
  "UCmOqH-yFMQzK11FCtihf2Pw",
  "UCEA2_fLyEwmDKeP8nFikMrA",
  "UC69c-jtTf0VU0tRdOLij1tg",
  "UCXylA9BrLQzaqCR0wNH_nwQ",
  "UCXaty-UbYsd8CR3mItUIpIw",
  "UC0fF9AKJ8xgI0AQB_i7OvTw",
  "UC9u7_jC9-dy9wDFcXkcc5GQ",
  "UCiaDfAYFMd2FrLjVukWbL-A",
  "UCrTphLe4-fZY3_jExXwvDaw",
  "UChgART3StWu3imxW_-OSCfQ",
  "UCmuNRTEvjlIsWYtA_D9N6hg",
  "UC0CH_H6YH2IOx7geHVegdJA",
  "UC37eSSOTbmkK2wGqBR1jNxQ",
  "UC8cotMFR6rXJG1qm9UGA-UA",
  "UCvWOCCXfnLPEINvIbCwB-8Q",
  "UCcazzPDnLTBJb9PNHhj27lw",
  "UCo9z_M0mI_kKORKjDxlsxvA",
  "UCLXYD8PJtnq-8W9kfJScGew",
  "UCpBxnaH_4cM_abBG9ES2sSQ",
  "UCV4c4hulnbuVPm-mjd3AFjg",
  "UCSxL3mufdJKVRpp4jhCDJgw",
  "UCTA-Sz9OPi3kardPDlg2Bfw",
  "UCvvshPssO0mVIKBmLaOKMgg"
  // Add other channel IDs here...
];

//videoIds for special Collection

const List<Map<String, String>> videoIds = [
  {'videoId':'k-2_nkbey8Y',"title":"Newspaper Doll" ,"description":"Create an interesting doll using Newspaper use it in your room decoration and showcase your creativity\n\nMaterials:\n  Newspaper\n  Notebook Cover Page\n  Cardboard\n  Thread\n  Acrylic Paints\n  White Glue"},
  {'videoId':'jt6cBhSupXk', "title":"Recycle Coconut Shell","description":"Create an Amazing wall hangings using coconut shell Make you child or siblings happy by creating it with easy steps\n\nMaterials:\n  Coconut shell\n  Acrylic Paint\n  chart papers\n  Peanut cover"},
  {'videoId':'dDrd9t1qRys', "title":"Cycle with Cups","description":"Make this Creative DIY.Create Cycle by using Paper Cup in which you can put anything you want\n\nMaterials:\n  Paper Cup\n  Marker\n  Newspaper\n  Scissor\n  Hot glue gun\n  Colors of your choice"},
  {'videoId':'0VE1HtBwPzg', "title":"Flower Vase","description":"Create this beautiful flower vase using waste clothes\n\nMaterials:\n  Bamboo Stick\n  newspaper\n  waste clothes\n  acrylic green color\n  needle and thread\n  artificial leaf\n  waste card boards\n  hot glue gun\n  floral foam"},
  {'videoId':'syAJfnSTokI', "title":"Showpiece","description":"Create A beautiful Home Decor using waste card boards and give enthusiasm to your creativity\n\nMaterials:\n  Waste card boards\n  glue\n  scissors\n  remain of tape\n  tissue\n  wall putty\n  tooth pick or any sharp thing\n  Acrylic paint\n  hot glue gun"},
  {'videoId':'M3TOKTHYc3g', "title":"Mini dustbin","description":"Create a mini dustbin for playing purpose or for keeping study wastes like sharpner waste\n\nMaterials:\n  paper cups\n  scissor\n  small cardboard pieces\n  glue\n  tooth pick\n  candy stick"},
  {'videoId':'AEd3f9qYy5s', "title":"Mini dholak","description":"Make this amazing musical instrument using paper cups\n\nMaterial:\n  paper cups\n  glue\n  tape\n  glue water paste\n  color\n  chart paper\n  scissors\n  needle\n  thread\n  beads"},
  {'videoId':'D-QUZtT7E-M', "title":"dream catcher","description":"Make this amazing dream catcher to catch your dreams and creativity\n\nMaterials:\n  bangle\n  woolen thread"},
];

//different categories i.e accesories,electric,
class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}



////////////////////////////////Card widgets with gradient//////////////////////////

Widget buildFactCard(String title, String description, Color color1, Color color2) {
  return Container(
    width: 200, // Fixed card width
    margin: EdgeInsets.only(right: 10), // Spacing between cards
    child: Card(
      elevation: 10, // Adds shadow effect to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Adds some rounding to the card corners
      ),
      child: Container(
        height: 210, // Fixed height for all cards
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Match border radius to card
          gradient: LinearGradient(
            colors: [color1, color2], // Gradient with two custom colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Almendra"
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: Colors.white70, // Lighter color for the description
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/////////////////////////////////User Name Widget////////////////////////////////////////////
class UserNameWidget extends StatelessWidget {
  const UserNameWidget({Key? key}) : super(key: key);

  Future<String?> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userData = await FirebaseFirestore.instance.collection('user').doc(uid).get();
        if (userData.exists) {
          return userData['name'];
        }
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
    return null; // In case of an error or if user doesn't exist
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.lightBlue,); // Loading indicator while fetching
        } else if (snapshot.hasError) {
          return Text('Error loading user name'); // Display error message if needed
        } else if (snapshot.hasData && snapshot.data != null) {
          return Text(' ${snapshot.data}',style: TextStyle(fontSize: 22,color: Colors.black54,fontFamily: "StardosStencil"),); // Display fetched username
        } else {
          return Text('No user name found'); // If no username is found
        }
      },
    );
  }
}




