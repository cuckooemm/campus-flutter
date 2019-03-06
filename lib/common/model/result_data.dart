class ResultData {
  var data;
  bool ok;
  int code;
  var headers;
  String msg;

  ResultData(this.ok, this.code,{this.data, this.headers,this.msg});
}