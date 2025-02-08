import 'package:flutter/material.dart';
import 'category_details.dart';
class AccessoriesDetailsPage extends StatefulWidget {
  const AccessoriesDetailsPage({super.key});

  @override
  State<AccessoriesDetailsPage> createState() => _AccessoriesDetailsPageState();
}

class _AccessoriesDetailsPageState extends State<AccessoriesDetailsPage> {
  final List<String> imageUrls = [
    'https://5.imimg.com/data5/SELLER/Default/2021/5/LX/TZ/RD/88685674/pearl-handmade-accessories.jpeg',
    "https://phuljhadi.com/cdn/shop/files/0J7A0278copy_600x.jpg?v=1716021021",
    "https://m.media-amazon.com/images/I/718uL4IVQyL._AC_UY1100_.jpg",
    'https://i.pinimg.com/736x/e6/61/21/e66121b1b93f3ca46a855c7d97a58675.jpg',
    "https://m.media-amazon.com/images/I/61mVtJwuRvL._AC_UF1000,1000_QL80_.jpg",
    "https://image.made-in-china.com/2f0j00IQWbjLDlgAzr/Wholesale-Fashion-Handmade-Solid-Color-Wrinkled-Satin-Fabric-Hairband-Women-Pearl-Headband-Hair-Accessories-for-Girls.webp",
    "https://pbs.twimg.com/media/Eeb6utnX0AYiEqn?format=jpg&name=large",
    "https://phuljhadi.com/cdn/shop/products/0J7A1534copy_600x.jpg?v=1676721499",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3NTxEdmz4A4LRu8s3lR458uUcUJKKC0P89AUVhTTSCDBqg4abU9e3KkTZiLj2gUYEsIk&usqp=CAU"
    // Add more URLs of images related to waste-to-use projects
  ];

  final title = 'Accessories';// Title for the category
  final description= "Elevate your style with handcrafted accessories! Explore a world of DIY creativity, where you can turn simple materials into beautiful jewelry, chic bags, and eye-catching embellishments. Unleash your imagination and create one-of-a-kind pieces that express your unique personality!";
  final building_card=[["hello","hey"],["hellllo","hhhhe"]];
  final t_1 = "Master Jump Rings";
  final t_2="Upcycled Fashion Accessories";
  final t_3="Avoid Tarnish";
  final d_1="Create unique earrings, necklaces, and bracelets using beads, wire, and charms.";
  final d_2="Transform old fabrics and clothes into trendy bags, belts, and hairbands.";
  final d_3="Store metal accessories in zip bags to prevent tarnishing.";
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
      anime: "animations/accessories.json",
    );
  }
}
