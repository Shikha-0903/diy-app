import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:lottie/lottie.dart";
import 'authentication/loginpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class next extends StatefulWidget {
  const next({super.key});

  @override
  State<next> createState() => _nextState();
}

class _nextState extends State<next> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("animations/page1.json",height:300,width:300,repeat: true,fit:BoxFit.cover,reverse: true),
                  SizedBox(height:30),
                  Text("let's make our own creation!!",style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Discover creative DIY projects with step-by-step guides.",style: TextStyle(fontSize: 18,color: Colors.black54,),textAlign: TextAlign.center),
                  ),
                ],
              ),
              Container(
                color: Colors.lightBlueAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("animations/girly.json",height:300,width:300,fit:BoxFit.cover,reverse: true),
                    Text("Exchange Ideas",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    SizedBox(height:20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Connect with fellow DIY enthusiasts and share your creations.",style: TextStyle(fontSize: 18,color: Colors.white,),textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("animations/explore.json",fit: BoxFit.fitWidth,reverse: true),
                    ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=> login()));}, child: Text("go to login",style: TextStyle(color: Colors.lightBlueAccent),),style: ElevatedButton.styleFrom(backgroundColor:Colors.white,shadowColor: Colors.black,/*shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))*/),)
                  ],
              ),
            ],

          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  expansionFactor: 4,
                  dotWidth: 8.0,
                  dotHeight: 8.0,
                  dotColor: Colors.black12,
                  activeDotColor: Colors.black
                )
              ),
            ),
          ),
        ],
      )
    );
  }
}

