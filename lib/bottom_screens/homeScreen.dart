import 'package:flutter/material.dart';
import 'package:shikha_tycs/categories/category_details.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../categories/origami.dart';
import '../categories/homedecor_details.dart';
import '../categories/waste_to_use_details.dart';
import '../categories/accessories_details.dart';
import 'package:shikha_tycs/constants.dart';
import 'festival.dart';
import 'package:shikha_tycs/video/video_player_screen.dart'; // Assuming videoIds are declared here
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shikha_tycs/video/special_video.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final List<Category> categories = [
    Category(name: 'Waste to Use', imageUrl: 'images/waste_to_use.png'),
    Category(name: 'Origami', imageUrl: 'images/craft.jpg'),
    Category(name: 'Home decor', imageUrl: 'images/home.png'),
    Category(name: 'Accessories', imageUrl: 'images/accessories.jpg'),
  ];
  // List of motivational quotes and corresponding animation files
  final List<Map<String, String>> quotesWithAnimations = [
    {
      "quote": "Creativity is intelligence of having fun.",
      "animation": "animations/ani2.json"
    },
    {
      "quote": "Do it yourself, because nothing feels as good as your own work!",
      "animation": "animations/ani1.json"
    },
    {
      "quote": "Turn waste into wonders with your own hands.",
      "animation": "animations/ani3.json"
    },
    {
      "quote": "The best way to predict the future is to create it.",
      "animation": "animations/ani4.json"
    },
    {
      "quote": "DIY is the art of turning the ordinary into the extraordinary.",
      "animation": "animations/ani5.json"
    },
  ];

  void navigateToCategoryPage(String categoryName) {
    switch (categoryName) {
      case 'Waste to Use':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WasteToUseDetailsPage(),
          ),
        );
        break;
      case 'Home decor':
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>HomedecorDetailsPage()
            ),
        );
      case 'Origami':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrigamiDetailsPage(),
          ),
        );
        break;
      case 'Accessories':
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context)=>AccessoriesDetailsPage()
          ),
        );
    }
  }

  void navigateToVideoScreen(String videoId, String title, String description,String thumbnail) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerScreen_s(videoId: videoId, title: title, description: description,thumbnail: thumbnail,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Welcome!",style: TextStyle(color: Colors.black54,fontFamily: "StardosStencil"),),
            UserNameWidget(),
          ],
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // PageView for motivational quotes with different animations
                Container(
                  height: 200, // Adjust height as needed
                  color: Colors.lightBlue,
                  /*decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue,Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),*/
                  child: PageView.builder(
                    itemCount: quotesWithAnimations.length,
                    controller: _pageController, // Slightly reduce the size for a 'peek' effect
                    itemBuilder: (context, index) {
                      final quoteData = quotesWithAnimations[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding to create space between pages
                        child: Card(
                          color: Colors.black12,
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            children: [
                              Lottie.asset(
                                quoteData["animation"]!,
                                fit: BoxFit.fitHeight,
                                width: double.infinity,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    quoteData["quote"]!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                SmoothPageIndicator(
                    controller: _pageController,
                    count: quotesWithAnimations.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.lightBlue,
                      dotColor: Colors.black54,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      expansionFactor: 3
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          navigateToCategoryPage(categories[index].name);
                        },
                        child: GridTile(
                          child: Image.asset(categories[index].imageUrl, fit: BoxFit.cover),
                          footer: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: GridTileBar(
                              title: Text(
                                categories[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Festival()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image(image: AssetImage("images/fs.png")),
                        Positioned(
                          bottom: 35,
                          left: 0,
                          right: 0,
                          child: Text(
                            "Let's celebrate all the festivals\nwith DIY making",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "NotoSerif"
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          left: 0,
                          right: 0,
                          child: TextButton(
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Festival()));
                              },
                              child: Text(
                                "Tap to know more",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "NotoSerif"
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  //color: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Special Collection", style: TextStyle(
                        fontSize: 18,
                        fontFamily: "StardosStencil",
                    )),
                  ),
                ),

                SizedBox(height: 5),

                Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videoIds.length,
                    itemBuilder: (context, index) {
                      final video = videoIds[index];
                      final videoId = video['videoId'];
                      final title = video['title'];
                      final description = video["description"];
                      final videoThumbnailUrl = YoutubePlayer.getThumbnail(videoId: videoId!);

                      return GestureDetector(
                        onTap: () {
                          navigateToVideoScreen(videoId!, title!, description!,videoThumbnailUrl!);
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              Image.network(
                                videoThumbnailUrl,
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                              Text(
                                '$title',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DIY Facts & Tips",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "StardosStencil"
                          /*shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              offset: Offset(2.0, 2.0),
                              color: Colors.black54
                            )
                          ]*/
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildFactCard(
                              "DIY Reduces Stress",
                              "• Crafting calms the mind\n• Known as 'craft therapy'",
                              Colors.pink,
                              Colors.lightBlue,
                            ),
                            buildFactCard(
                              "Eco-Friendly Crafts",
                              "• Use recyclables in DIY\n• Reduce waste and help the planet",
                              Colors.greenAccent,
                              Colors.lightBlue,
                            ),
                            buildFactCard(
                              "Use Recyclables",
                              "• Repurpose jars and clothes\n• Turn trash into art",
                              Colors.orangeAccent,
                              Colors.lightBlue,
                            ),
                            buildFactCard(
                              "Stay Organized",
                              "• Sort materials by type\n• Be ready when inspiration strikes",
                              Colors.purpleAccent,
                              Colors.lightBlue,
                            ),
                            buildFactCard(
                              "Personalize Your Projects",
                              "• Add your style to each craft\n• Make every project unique",
                              Colors.grey,
                              Colors.lightBlue,
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
