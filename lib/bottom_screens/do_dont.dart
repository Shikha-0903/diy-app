import 'package:flutter/material.dart';
import 'package:shikha_tycs/pop up.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            //image: DecorationImage(image: NetworkImage("https://e1.pxfuel.com/desktop-wallpaper/75/569/desktop-wallpaper-sky-blue-colour-light-blue-colour-thumbnail.jpg"),fit: BoxFit.cover)
            gradient: LinearGradient(colors: [Colors.lightBlue,Colors.white],begin: Alignment.topLeft,end: Alignment.bottomRight)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Tap and Explore Do's and Don'ts",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "StardosStencil"),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Do's",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
                HeadingCard(heading: "Do plan ahead", subHead: "Have a clear vision of the final project before starting. Gather all materials, tools, and instructions beforehand."),
                HeadingCard(heading: "Do use proper tools", subHead: "Ensure you are using the right tools for the job. Sharp scissors, quality glue, and the appropriate cutting tools can make a huge difference in the outcome."),
                HeadingCard(heading: "Do keep your workspace clean", subHead: "A clutter-free workspace minimizes mistakes and accidents. It also gives you more space to work comfortably."),
                HeadingCard(heading: "Do follow safety guidelines", subHead: "Wear safety goggles and gloves when necessary, especially when cutting or using hazardous materials like hot glue or sharp tools."),
                HeadingCard(heading: "Do take breaks", subHead: "Take short breaks to avoid fatigue, especially during lengthy or intricate projects. This ensures you stay focused and precise."),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Don'ts",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
                HeadingCard(heading: "Don’t rush", subHead: "Patience is key in DIY projects. Rushing can lead to mistakes, messes, and accidents."),
                HeadingCard(heading: "Don’t use excessive glue or paint", subHead: "A little glue or paint often goes a long way. Using too much can make the project look sloppy or cause parts to come apart."),
                HeadingCard(heading: "Don’t ignore safety precautions", subHead: "Avoid using tools without proper knowledge. Always follow instructions for power tools, and don’t skip safety gear when needed."),
                HeadingCard(heading: "Don’t cut towards yourself", subHead: "Always cut away from your body to prevent injuries from sharp tools like knives or scissors."),
                HeadingCard(heading: "Don’t get discouraged by mistakes", subHead: "Mistakes are part of the creative process. Learn from them and improvise solutions rather than giving up.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
