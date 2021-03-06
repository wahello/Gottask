import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final int imageLinkIndex;
  final List<File> imageLinkList;
  final Color color;
  const ImageViewer({this.imageLinkIndex, this.imageLinkList, this.color});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  PageController pageController;
  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.imageLinkIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              itemCount: widget.imageLinkList.length,
              builder: (context, index) => PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(widget.imageLinkList[index]),
                  initialScale: PhotoViewComputedScale.contained,
                ),
            ),
            // PhotoView(
            //       minScale: PhotoViewComputedScale.contained,
            //       imageProvider: FileImage(
            //         widget.imageLinkList[index],
            //         scale: 1,
            //       ),
            //     );
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: SafeArea(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                    color: widget.color,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Ionicons.ios_arrow_back,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
