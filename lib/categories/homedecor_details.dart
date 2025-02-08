import 'package:flutter/material.dart';
import 'category_details.dart'; // Import the reusable model

class HomedecorDetailsPage extends StatefulWidget {
  const HomedecorDetailsPage({super.key});

  @override
  State<HomedecorDetailsPage> createState() => _HomedecorDetailsPageState();
}

class _HomedecorDetailsPageState extends State<HomedecorDetailsPage> {
  final List<String> imageUrls = [
    'https://media.designcafe.com/wp-content/uploads/2020/09/30172859/diy-wall-hanging-craft-ideas.jpg',
    'https://nestasia.in/cdn/shop/collections/IMG_3477.jpg?v=1690614866',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUUtLrQsYIzNQPPWYSnXgBKTUjaanAS5sbMg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeitbzK-xuCbF5LDV4KZtjm2DNsSSQDyZhCA&s",
    "https://www.francinesplaceblog.com/wp-content/uploads/2023/08/diy-donut-vase-air-clay-orhanic-shape-decor-home-easy-tutorial-vase-faidate-ciambella-argilla-casa-francinesplaceblog-10-scaled.jpg",
    "https://www.gimv.org/wp-content/uploads/2022/03/iStock-1163252391.jpg",
    "https://i.ytimg.com/vi/aT1sxD_gzFo/mqdefault.jpg",
    "https://www.craft-e-corner.com/cdn/shop/articles/IMG_8235.jpg?v=1558978740",
    "https://i.pinimg.com/736x/a0/73/c3/a073c337853612309a920c30201b6ca8.jpg"

    // Add more URLs of images related to waste-to-use projects
  ];
  final title = 'Home Decor';// Title for the category
  final description= 'Transform your space with DIY home decor! From simple crafts to stylish designs, you can add a personal touch to any room. Whether it’s wall art, cozy candles, or upcycled furniture, make your home a reflection of your creativity and style!';
  final t_1 = "Use Fabric Scraps for Pillows";
  final t_2 = "Create Wall Art from Recycled Materials";
  final t_3 = "Make Your Own Candles";
  final d_1 = "Sew or glue fabric scraps into stylish pillow covers for a pop of color.";
  final d_2 = "Combine cardboard, wood, or metal scraps to design unique wall decor.";
  final d_3 = "Melt wax and pour it into molds for personalized scented candles.";

  @override
  Widget build(BuildContext context) {
    return CategoryModel(
      title: title,
      description: description,
      imageUrls: imageUrls,
      t_1: t_1,
      t_2: t_2,
      t_3: t_3,
      d_1: d_1,
      d_2: d_2,
      d_3: d_3,
      anime: "animations/home.json",
    );
  }
}
