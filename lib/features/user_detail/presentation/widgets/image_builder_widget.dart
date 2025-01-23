import 'package:flutter/material.dart';

class ImageBuilderWidget extends StatelessWidget {
  final String imageUrl;

  const ImageBuilderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), // Rounded corners
          border: Border.all(color: Colors.black, width: 1), // Optional border
        ),
        clipBehavior: Clip.hardEdge,
        child: Image(
          image: NetworkImage(imageUrl),
          loadingBuilder:
              (BuildContext context, Widget child, ImageChunkEvent? loading) {
            if (loading == null) return child;
            return SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: loading.expectedTotalBytes != null
                    ? loading.cumulativeBytesLoaded /
                        loading.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
