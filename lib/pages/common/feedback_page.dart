import 'package:campus/common/dao/common_dao.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage>{

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("反馈建议"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              maxLines: 7,
              controller: _contentController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
                  hintText: "有什么好的建议或者BUG 都可以在这里告诉我哦~",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
              maxLength: 500,
              style: ContextStyle.inputContent,
              keyboardType: TextInputType.text,
              onChanged: (String value) {},
            ),
          ),
          SizedBox(
            height: 45.0,
            width: 270.0,
            child: RaisedButton(
              child: Text(
                "提交",
                style: Theme.of(context).accentTextTheme.headline,
              ),
              color: Color(GlobalColors.primaryValue),
              onPressed: () {
                if(_contentController.text.length >0 ){
                  sendFeedback(_contentController.text);
                }else{
                  ToastUtils.showShortWarnToast(StringTip.say_something_tip);
                }
              },
              shape: StadiumBorder(side: BorderSide()),
            ),
          )
        ],
      ),
    );
  }

  sendFeedback(String content) async {
    CommonUtils.showLoadingDialog(context, "发送反馈中…");
    Message result = await CommonDao.sendFeedback(content);
    Navigator.pop(context);
    if(result.ok){
      Navigator.pop(context);
      ToastUtils.showShortSuccessToast(result.msg);
    }else{
      ToastUtils.showShortErrorToast(result.msg);
    }
  }
}