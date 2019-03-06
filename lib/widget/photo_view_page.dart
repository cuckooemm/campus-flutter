import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper  extends StatefulWidget{
  final List<String> url;
  final int position;
  GalleryPhotoViewWrapper (this.url,this.position);

  @override
  State<StatefulWidget> createState() => _GalleryPhotoViewWrapper();
}
class _GalleryPhotoViewWrapper extends State<GalleryPhotoViewWrapper >{
  int currentIndex;
  PageController controller;
  @override
  void initState() {
    currentIndex = widget.position;
    controller = PageController(initialPage: widget.position);
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          PhotoViewGallery(
            pageController: controller,
            pageOptions: List.generate(widget.url.length, (index){
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.url[index]),
              );
            }).toList(),
            onPageChanged: onPageChanged,
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text("${currentIndex + 1}",
            style: const TextStyle(
                color: Colors.white, fontSize: 17.0, decoration: null)),
          )
        ],
      ),
    );

  }
}