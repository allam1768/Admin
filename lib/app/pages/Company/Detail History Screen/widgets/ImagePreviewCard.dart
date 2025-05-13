import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewCard extends StatelessWidget {
  final String imageUrl;
  final String imageTitle;

  const ImagePreviewCard({
    Key? key,
    required this.imageUrl,
    required this.imageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImagePreview(context, imageUrl);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.025),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent, // Biar nggak ada background putih
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.03),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.025),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
