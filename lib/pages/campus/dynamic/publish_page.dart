import 'dart:io';

import 'package:campus/common/dao/dynamic_dao.dart';
import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/oss_sign.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/widget/show_nine_image_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class DynamicPublishPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DynamicPublishPage();
}

class _DynamicPublishPage extends State<DynamicPublishPage>
    with LoadingDelegate {
  final TextEditingController _contentController = TextEditingController();

  List<AssetEntity> imgList = <AssetEntity>[];
  List<File> compressImageList = <File>[];
  List<String> imageKey = <String>[];
  List<String> imageFailKey = <String>[];
  int imageMaxSize = 1200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发布动态"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              maxLines: 7,
              controller: _contentController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                  hintText: StringTip.say_something_tip,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
              maxLength: 500,
              style: ContextStyle.inputContent,
              keyboardType: TextInputType.text,
              onChanged: (String value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: ShowNineImageWidget(compressImageList),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          key: Key("buttonPublish"),
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Text("图片"),
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  _pickImage();
                },
              ),
              flex: 1,
            ),
            Expanded(
              child: FlatButton(
                child: Text("发布"),
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  if (CommonUtils.getGlobalStore(context)?.state?.token?.isLogin ?? false) {
                    if (_contentController.text.length > 0) {
                      onFrontPublish();
                    } else {
                      ToastUtils.showShortWarnToast(
                          StringTip.say_something_tip);
                    }
                  } else {
                    ToastUtils.showShortWarnToast(StringTip.after_login);
                  }
                },
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    imgList.clear();
    imgList = await PhotoPicker.pickImage(
      context: context,
      themeColor: Colors.blue,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      maxSelected: 9,
      provider: I18nProvider.chinese,
      rowCount: 3,
      textColor: Colors.white,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      loadingDelegate: this,
    );
    if (!ObjectUtils.isEmptyList(imgList)) {
      compressImage();
    }
  }

  compressImage() async {
    compressImageList.clear();
    CommonUtils.showCompressDialog(context);
    for (AssetEntity image in imgList) {
      var file = await image.file;
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file.path);
      File compressFile;
      if (properties.height > imageMaxSize || properties.width > imageMaxSize) {
        if (properties.width > properties.height) {
          compressFile = await FlutterNativeImage.compressImage(file.path,
              quality: 80,
              targetWidth: imageMaxSize,
              targetHeight:
                  (properties.height / properties.width * 1200).toInt());
        } else {
          compressFile = await FlutterNativeImage.compressImage(file.path,
              quality: 80,
              targetWidth:
                  (properties.width / properties.height * 1200).toInt(),
              targetHeight: imageMaxSize);
        }
      } else {
        compressFile = await FlutterNativeImage.compressImage(file.path,
            quality: 80, percentage: 80);
      }
      compressImageList.add(compressFile);
    }
    Navigator.pop(context);
    // 更新视图
    setState(() {});
  }

  @override
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  @override
  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  onUploadImage(OssSign ossSign) async {
    CommonUtils.showLoadingDialog(context, "图片上传中…");
    for (File img in compressImageList) {
      String key = "dynamic/" + CommonUtils.getUUIDString();
      Message result = await UserDao.uploadImageToOss(ossSign.host, key,
          ossSign.policy, ossSign.accessid, ossSign.signature, img);
      if (result.ok) {
        imageKey.add(key);
      } else {
        imageFailKey.add(key);
      }
    }
    if (!ObjectUtils.isEmptyList(imageFailKey)) {
      ToastUtils.showShortWarnToast("${imageFailKey.length}张图片上传失败");
    }
    closeLoading();
  }

  onFrontPublish() async {
    if (!ObjectUtils.isEmptyList(compressImageList)) {
      CommonUtils.showLoadingDialog(context, "准备上传图片中…");
      // 获取签名
      OssSign ossSign = await UserDao.getOssSign(context);
      if (ossSign.ok) {
        // 清除imageKey
        closeLoading();
        imageKey.clear();
        await onUploadImage(ossSign);
        FormData data = FormData.from(
            {"content": _contentController.text, "images": imageKey.join(",")});
        onPublish(data);
      } else {
        closeLoading();
        ToastUtils.showShortErrorToast(ossSign.msg);
      }
    } else {
      // 直接上传文本
      FormData data = FormData.from({
        "content": _contentController.text,
      });
      onPublish(data);
    }
  }

  onPublish(FormData param) async {
    CommonUtils.showLoadingDialog(context, "正在上传动态…");
    Message result =
        await DynamicDao.publishDynamic(context, param);
    if (result.ok) {
      ToastUtils.showShortSuccessToast(result.msg);
      closeLoading();
      Navigator.pop(context);
    } else {
      ToastUtils.showShortErrorToast(result.msg);
      closeLoading();
    }
  }

  // 关闭动画
  closeLoading() {
    Navigator.pop(context);
  }
}
