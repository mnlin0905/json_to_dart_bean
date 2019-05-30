//******************************************************************
//**************************** Generate By JsonToDartBean  **********
//**************************** Wed May 29 15:13:47 CST 2019  **********
//******************************************************************



import 'package:json_holder_impl/json_holder_impl.dart';

class TestBean with JsonHolderImpl<TestBean> {
  /// [key : value] => [outName : nnn]
  String get outName => getValue("outName");
  set outName(String value) => setValue("outName", value);

  /// [key : value] => [outAge : 12]
  int get outAge => getValue("outAge");
  set outAge(int value) => setValue("outAge", value);

  /// [key : value] => [obj : null]
  ObjBean get obj => getValue("obj");
  set obj(ObjBean value) => setValue("obj", value);

  /// [key : value] => [datas : null]
  List<DatasBean> get datas => getValue("datas");
  set datas(List<DatasBean> value) => setValue("datas", value);

  TestBean.fromJson([Map<String, dynamic> json]) {
    fromJson(json);
    ObjBean.fromJson();
    DatasBean.fromJson();
  }

  @override
  JsonHolderImpl<TestBean> provideCreator(Map<String, dynamic> json) {
    return TestBean.fromJson(json);
  }

  @override
  List<TestBean> provideListCreator() {
    return <TestBean>[];
  }

  @override
  List<List<TestBean>> provideListListCreator() {
    return <List<TestBean>>[];
  }

}

class ObjBean with JsonHolderImpl<ObjBean> {
  /// [key : value] => [innerName : 12ss]
  String get innerName => getValue("innerName");
  set innerName(String value) => setValue("innerName", value);

  /// [key : value] => [innerAge : 34]
  int get innerAge => getValue("innerAge");
  set innerAge(int value) => setValue("innerAge", value);

  ObjBean.fromJson([Map<String, dynamic> json]) {
    fromJson(json);
  }

  @override
  JsonHolderImpl<ObjBean> provideCreator(Map<String, dynamic> json) {
    return ObjBean.fromJson(json);
  }

  @override
  List<ObjBean> provideListCreator() {
    return <ObjBean>[];
  }

  @override
  List<List<ObjBean>> provideListListCreator() {
    return <List<ObjBean>>[];
  }

}

class DatasBean with JsonHolderImpl<DatasBean> {
  /// [key : value] => [key1 : textValue1]
  String get key1 => getValue("key1");
  set key1(String value) => setValue("key1", value);

  /// [key : value] => [key2 : true]
  bool get key2 => getValue("key2");
  set key2(bool value) => setValue("key2", value);

  /// [key : value] => [key3 : 34]
  int get key3 => getValue("key3");
  set key3(int value) => setValue("key3", value);

  /// [key : value] => [key4 : textValue4]
  String get key4 => getValue("key4");
  set key4(String value) => setValue("key4", value);

  /// [key : value] => [key5 : true]
  bool get key5 => getValue("key5");
  set key5(bool value) => setValue("key5", value);

  DatasBean.fromJson([Map<String, dynamic> json]) {
    fromJson(json);
  }

  @override
  JsonHolderImpl<DatasBean> provideCreator(Map<String, dynamic> json) {
    return DatasBean.fromJson(json);
  }

  @override
  List<DatasBean> provideListCreator() {
    return <DatasBean>[];
  }

  @override
  List<List<DatasBean>> provideListListCreator() {
    return <List<DatasBean>>[];
  }

}

