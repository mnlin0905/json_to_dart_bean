import 'package:flutter_test/flutter_test.dart';

import 'TestBean.dart';

void main(){
  test("create bean", (){
    // 测试数据
    var json = {
      "outName":"nnn",
      "outAge":12,
      "obj":{
        "innerName":"12ss",
        "innerAge":34
      },
      "datas":[
        {
          "key1":"textValue1",
          "key2":true,
          "key3":34.0
        },
        {
          "key4":"textValue4",
          "key5":true,
          "key3":1
        },
        {
          "key1":null,
          "key2":false,
          "key3":11
        },
        {

        }
      ]
    };

    var a = TestBean.fromJson(json);

    print(a);
    print(a.datas);
    print(a.obj);
    print(a.outAge);
    print(a.outName);
  });
}