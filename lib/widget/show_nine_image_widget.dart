import 'dart:io';

import 'package:campus/common/utils/object_utils.dart';
import 'package:flutter/material.dart';

/// 九宫格
class ShowNineImageWidget extends StatelessWidget {
  ShowNineImageWidget(this.image, {Key key}) : super(key: key);
  final List<File> image;

  @override
  Widget build(BuildContext context) {
    if (ObjectUtils.isEmptyList(image)) {
      return SizedBox(width: 0.0, height: 0.0);
    } else {
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(2.0),
          crossAxisCount: 3,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
          children: List.generate(image.length, (index){
            return getItemWidget(context,index);
          }),
        );
    }
  }

  Widget getItemWidget(BuildContext context,int index) {
    return InkWell(
      onTap: (){
//        NavigatorUtils.gotoPhotoViewPage(context, image[index].path, index);
      },
      child: Image.file(image[index],fit: BoxFit.fill,),
    );
  }

}
