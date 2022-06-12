import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  MusicCard(
      {this.title,
      this.lebel,
      this.url,
      this.containerHeight,
      this.containerWidth,
      this.imageHeight,
      this.imagewidth,
      this.textColor,
      this.imageUrl});
  String? title, lebel, url, imageUrl;
  double? imageHeight = 0.0, imagewidth = 0.0;
  double? containerHeight = 0.0, containerWidth = 0.0;
  Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      // color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl!,
            height: imageHeight,
            width: imagewidth,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title!,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            lebel!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
