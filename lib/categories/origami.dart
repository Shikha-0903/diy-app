import 'package:flutter/material.dart';
import 'category_details.dart';

class OrigamiDetailsPage extends StatefulWidget {
  const OrigamiDetailsPage({super.key});

  @override
  State<OrigamiDetailsPage> createState() => _OrigamiDetailsPageState();
}

class _OrigamiDetailsPageState extends State<OrigamiDetailsPage> {
  final List<String> imageUrls = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/2014_Origami_modu%C5%82owe.jpg/640px-2014_Origami_modu%C5%82owe.jpg',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmyl0hDG1HM3uncm0nzvQfLUbOggthxixfCw&s"
    'https://images.squarespace-cdn.com/content/v1/54005a0ce4b0bbe0fce8fac5/bee88c6f-4b00-4c1f-ad59-8565ab101832/1.jpg',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRispRe4kng-gaQVlZmloxHPkY8DpyuJIcqMA&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREnu2IP3pnfqdgws0T2hfrIHuAzJQPZmHUMg&s",
    "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiN70LHfSKHBp86P3Dm7cvvhVGjVeAX_eycnXXQHjOCyx7pcB7rM6GpJBDLmJrB13U8Ey52aye6FgCuh4L0ijTHS_LAEor5I_d1igityVPawkDyOHss1LCqEtryMxIlCrbcAIpzGDiiWBGB/s1600/Origami-Crown-Paper-Craft-Kids-2.jpg",
    "https://i.pinimg.com/736x/3a/d8/54/3ad854cb4ace34af49e32827e8a4a98f.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZBBzS8XaZZ9oOcnhY3_tPX3eSJpw_wey1xw&s",
    "https://play-lh.googleusercontent.com/fVXrK8dCvtaZDkO3uWDcQJB52_ZwV1yKB2oSxPgV_AmeQepWys6uRseI8zHoeDvtsA",
    "https://cdn2.momjunction.com/wp-content/uploads/2015/07/Origami-Bird.jpg.webp"
    // Add more URLs of images related to waste-to-use projects
  ];
  final title = 'Origami';// Title for the category
  final description= "Turn a simple piece of paper into amazing creations! With origami, you can fold anything from cute animals to cool shapes. It’s easy, fun, and perfect for anyone who loves hands-on creativity. Dive in and start folding magic with just paper!";
  final t_1 = "Thin Paper Works Best";
  final t_2 = "Start with Simple Models";
  final t_3 = "Sharp Folds, Better Results";
  final d_1 = "Thin paper is ideal for detailed designs and easier folding.";
  final d_2 = "Master simple models before tackling complex ones.";
  final d_3 = "Press firmly for clean, crisp folds every time.";

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
      anime: "animations/origami.json",
    );
  }
}
