import 'package:flutter/material.dart';

class ShowDosDont extends StatefulWidget {
  final String h1;
  final String h2;
  const ShowDosDont({super.key, required this.h1,required this.h2});

  @override
  State<ShowDosDont> createState() => _ShowDosDontState();
}

class _ShowDosDontState extends State<ShowDosDont> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),  // Optional: Add padding for better appearance
            child: Text(widget.h1,style: TextStyle(color: Colors.lightBlueAccent,fontSize: 25,fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),  // Optional: Add padding for better appearance
            child: Text(widget.h2,style: TextStyle(fontSize: 18),),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();  // Close the dialog
          },
          child: const Text("Close",style: TextStyle(color: Colors.lightBlue),),
        ),
      ],
    );
  }
}

class HeadingCard extends StatefulWidget {
  final String heading;
  final String subHead;
  const HeadingCard({super.key,required this.heading,required this.subHead});

  @override
  State<HeadingCard> createState() => _HeadingCardState();
}

class _HeadingCardState extends State<HeadingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: double.infinity,
          child: Card(
            color: Colors.lightBlue,
            shadowColor: Colors.yellow,
            elevation: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                //image: DecorationImage(image: NetworkImage("https://e1.pxfuel.com/desktop-wallpaper/75/569/desktop-wallpaper-sky-blue-colour-light-blue-colour-thumbnail.jpg"),fit: BoxFit.cover)
                  gradient: LinearGradient(colors: [Colors.cyan,Colors.purple],begin: Alignment.topLeft,end: Alignment.bottomRight)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("${widget.heading}",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ),
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowDosDont(h1: "${widget.heading}",h2: "${widget.subHead}",);
            },
          );
        }
    );
  }
}
