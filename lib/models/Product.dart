import 'package:flutter/material.dart';

class Product {
  final String image, title, description, tag;
  final int price, id;
  final double size;
  final Color color;

  Product({
    required this.image,
    required this.title,
    required this.description,
    required this.tag,
    required this.price,
    required this.size,
    required this.id,
    required this.color,
  });
}

List<Product> productList = [
  Product(
      id: 1,
      title: "Demon",
      price: 234,
      size: 0.5,
      description: dummyText,
      tag: "beer",
      image: "assets/images/beer_1.png",
      color: const Color(0xFF1D1D1B)),
  Product(
      id: 2,
      title: "Ginevra ipa",
      price: 234,
      size: 0.5,
      description: dummyText,
      tag: "beer",
      image: "assets/images/beer_2.png",
      color: const Color(0xFF07B2E6)),
  Product(
      id: 3,
      title: "Aquila",
      price: 234,
      size: 0.5,
      description: dummyText,
      tag: "beer",
      image: "assets/images/beer_3.png",
      color: const Color(0xFFF9EF7B)),
  Product(
      id: 4,
      title: "Strong Ale",
      price: 234,
      size: 0.5,
      description: dummyText,
      tag: "beer",
      image: "assets/images/beer_4.png",
      color: const Color(0xFF373250)),
  Product(
      id: 5,
      title: "Black Dog",
      price: 234,
      size: 0.5,
      description: dummyText,
      tag: "beer",
      image: "assets/images/beer_5.png",
      color: const Color(0xFF007531)),
  Product(
    id: 6,
    title: "La trappe quadrupel",
    price: 234,
    size: 0.5,
    description: dummyText,
    tag: "beer",
    image: "assets/images/beer_6.png",
    color: const Color(0xFF6D431D),
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
