import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus/common/model/images_url.dart';
import 'package:campus/common/style/constant.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:flutter/material.dart';

/// 九宫格
class NineGridWidget extends StatelessWidget {
  NineGridWidget(this.image, {Key key}) : super(key: key);
  final ImagesUrl image;
  int count;

  @override
  Widget build(BuildContext context) {
    if (ObjectUtils.isEmpty(image) || ObjectUtils.isEmptyList(image.url)) {
      return SizedBox(width: 0.0, height: 0.0);
    } else {
      initCount();
      if (count > 1) {
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(2.0),
          crossAxisCount: count,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
          children: List.generate(image.url.length, (index){
            return getItemWidget(context,index);
          }),
        );
      } else {
        return AspectRatio(
          aspectRatio: 1.5,
          child: getItemWidget(context,0),
        );
      }
    }
  }

  Widget getItemWidget(BuildContext context,int index) {
    return InkWell(
      onTap: (){
        NavigatorUtils.gotoPhotoViewPage(context, image.urlOriginal, index);
      },
      child: CachedNetworkImage(
          key: Key(image.url[index]),
          imageUrl: image.url[index],
          fit: BoxFit.fill,
          errorWidget: Image.asset(Constant.image_loading_error)
      ),
    );
  }

  initCount() {
    count = image.url.length;
    if (count > 4) {
      count = 3;
    } else if (count > 1) {
      count = 2;
    }
  }
}
