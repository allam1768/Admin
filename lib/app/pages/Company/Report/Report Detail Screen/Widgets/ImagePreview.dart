import 'package:flutter/material.dart';

void ImagePreview(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.025),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      );
    },
  );
}
