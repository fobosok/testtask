// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imageUrl,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                enableRotation: false,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 60, // Положение кнопки от верхнего края
            right: 30, // Положение кнопки от правого края
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Полупрозрачный черный фон
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white, // Белый цвет иконки
                    size: 32, // Размер иконки
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
