import 'package:flutter/material.dart';
import 'category_details.dart'; // Import the reusable widget

class WasteToUseDetailsPage extends StatefulWidget {
  @override
  State<WasteToUseDetailsPage> createState() => _WasteToUseDetailsPageState();
}

class _WasteToUseDetailsPageState extends State<WasteToUseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Sample data for Waste to Use category
    final String title = 'Waste to Use';
    final String description = 'Transform waste into something amazing! Discover easy and fun ways to recycle everyday items into cool, useful creations. Let’s make the world greener, one craft at a time!';
    final List<String> imageUrls = [
      'https://assets-news.housing.com/news/wp-content/uploads/2022/02/05163324/Best-out-of-waste-ideas-to-decorate-your-home-bottle-art-image-01.jpg',
      'https://www.collettivovv.org/wp-content/uploads/2020/05/Paper-Bowl.jpg',
      "https://cms.interiorcompany.com/wp-content/uploads/2023/12/Use-Of-craft-by-Waste-Material-DIY-Mason-Jar-Lanterns.jpg",
      "https://www.nobroker.in/blog/wp-content/uploads/2020/05/Ideas-to-Decorate-Your-Home25.png",
      "https://images.herzindagi.info/image/2022/Jul/plant-pots-diy.jpg",
      "https://happiestcamper.com/wp-content/uploads/2019/06/Homemade-Earring-Holder-using-an-Upcycled-Cheese-Grater-An-inexpensive-and-eco-friendly-craft-idea-with-a-purpose-2-735x1110.jpg",
      "https://i.pinimg.com/736x/4a/c5/63/4ac56386a609bc9bc7ba290652b173ea.jpg",
      "https://www.fevicreate.com/o/commerce-media/accounts/795597346/images/381691484?download=false",
      "https://assets-news.housing.com/news/wp-content/uploads/2022/02/07233512/Best-out-of-waste-ideas-to-decorate-your-home-06.png"
      // Add more URLs of images related to waste-to-use projects
    ];

    final t_1 = "Repurpose Plastic Bottles";
    final t_2 = "Turn Old Clothes into Rugs";
    final t_3 = "Use Tin Cans for Organizers";
    final d_1 = "Cut plastic bottles to create plant holders or storage containers.";
    final d_2 = "Weave old clothes into colorful, durable rugs for your home.";
    final d_3 = "Transform tin cans into desk organizers with a coat of paint.";


    return Scaffold(
      body: CategoryModel(
        title: title,
        description: description,
        imageUrls: imageUrls,
        t_1: t_1,
        t_2: t_2,
        t_3: t_3,
        d_1: d_1,
        d_2: d_2,
        d_3: d_3,
        anime: "animations/waste.json",
      ),
    );
  }
}
