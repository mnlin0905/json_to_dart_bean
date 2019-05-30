import 'dart:math';

/// model 父类
///
/// 注意: 此为浅拷贝基类对象,如果用于赋值对象可能后期有更改,则需要自行拷贝然后再次赋值
///
/// 注意:后台返回值可能和目标输出值有所不同,因类型转换的存在,在具体调用某个字段时,类型值已发生变化
mixin JsonHolderImpl<T> {
  /// 是否开启缓存模式
  ///
  /// 后台针对int类型返回了double数据,在第一次调用之后,系统其实已经做了一次 double -> int的处理, isCacheMode 为 true 时,会使用本次处理结果替代原有的格式错误的数据,false 表示不进行替换
  /// 开启缓存模式后,在第一次调用属性之后,第二次调用时速度会变快(因此不需要再去做数据格式转换的操作)
  static final bool isCacheMode = false;

  ///目标转换工具(针对基本类型和String)(int double num bool(bool除转换为bool值,其他情况很可能会出错) String)
  ///json值为 [value.runtimeType] 类型,但需要的是  [type]  类型,此时需要使用转换器
  static final Function(dynamic value, String type) _convent = (value, type) {
    return (conventsMap["${value.runtimeType.toString()}=>$type"] ??
        (value) {
          //如果两者类型一致,才可以返回自身,否则判断是否有默认返回的值
          return (value.runtimeType.toString() == type || type  == "dynamic" || type == "Object")
              ? value
              : (conventsMap["Null=>$type"] ??
                  (value) {
                    //如果还是没有默认的值,那就直接返回null
                    return null;
                  })(value);
        })(value);
  };

  /// 内置基础类型转换器
  static final Map<String, Function> conventsMap = {
    "Null=>int": (value) {
      return 0;
    },
    "Null=>double": (value) {
      return .0;
    },
    "Null=>num": (value) {
      return 0;
    },
    "Null=>bool": (value) {
      return false;
    },
    "Null=>String": (value) {
      return null;
    },
    "int=>int": (value) {
      return value;
    },
    "int=>double": (value) {
      return value;
    },
    "int=>num": (value) {
      return value;
    },
    "int=>bool": (value) {
      return value != 0 && value != null;
    },
    "int=>String": (value) {
      return value.toString();
    },
    "double=>int": (value) {
      return value.toInt();
    },
    "double=>double": (value) {
      return value;
    },
    "double=>num": (value) {
      return value;
    },
    "double=>bool": (value) {
      return value != 0.0 && value != null;
    },
    "double=>String": (value) {
      return value.toString();
    },
    "num=>int": (value) {
      return value.toInt();
    },
    "num=>double": (value) {
      return value.toDouble();
    },
    "num=>num": (value) {
      return value;
    },
    "num=>bool": (value) {
      return value != 0 && value != null;
    },
    "num=>String": (value) {
      return value.toString();
    },
    "bool=>int": (value) {
      return 0;
    },
    "bool=>double": (value) {
      return .0;
    },
    "bool=>num": (value) {
      return 0;
    },
    "bool=>bool": (value) {
      return value;
    },
    "bool=>String": (value) {
      return value.toString();
    },
    "String=>int": (value) {
      return int.tryParse(value) ?? 0;
    },
    "String=>double": (value) {
      return double.tryParse(value) ?? .0;
    },
    "String=>num": (value) {
      return num.tryParse(value) ?? 0;
    },
    "String=>bool": (value) {
      //对于 true 不区分大小相同则为true
      return true.toString() == value.toString().toLowerCase();
    },
    "String=>String": (value) {
      return value;
    },
  };

  /// 提供一个类生成器
  /// 给定一个字符串,返回一个生成某具体对象的函数
  static Map<String, JsonHolderImpl Function(Map<String, dynamic>)> _jsonHolderFactory = {};
  static Map<String, List Function()> _jsonHolderListFactory = {
    "Object": () {
      return <Object>[];
    },
    "dynamic": () {
      return <dynamic>[];
    },
    "int": () {
      return <int>[];
    },
    "double": () {
      return <double>[];
    },
    "num": () {
      return <num>[];
    },
    "bool": () {
      return <bool>[];
    },
    "String": () {
      return <String>[];
    },
  };
  static Map<String, List Function()> _jsonHolderListListFactory = {
    "List<Object>": () {
      return <List<Object>>[];
    },
    "List<dynamic>": () {
      return <List<dynamic>>[];
    },
  };

  /// 保存map集合,对象先赋个初值,保证该方法不会返回null
  Map<String, dynamic> _innerMap;

  /// 由于map集合的存在,因此该方法直接返回内置map对象
  Map<String, dynamic> toJson() {
    return _innerMap ?? {};
  }

  /// 从json中生成bean对象
  /// 实际只是将json赋值给内置对象
  ///
  /// 注意:该方式是浅拷贝,因此务必保证此对象在之后不会被无意修改还是很慢反
  /// 注意:该方法只能调用一次,即合法情况下从json -> bean后,该bean不能再通过一个 json 初始化值
  /// 注意:如果一个bean从未调用该方法,那么所有对于其成员的操作(get/set时则提示出错),将没有任何意义
  T fromJson(Map<String, dynamic> json) {
    // 只要调用了该方法,就默认需要 进行值的存储,因此这里json不能为null
    if (json == null) {
      json = {};
    }

    //  禁止该方法调用多次
    if (_innerMap != null) {
      throw Exception("'FromJson' method, can only be called once");
    }

    // 提供一个类型解析器(用于生成单个bean)
    _jsonHolderFactory[T.toString()] = provideCreator;

    // 提供一个数组类型解析器(用于生成List)
    _jsonHolderListFactory[T.toString()] = provideListCreator;

    // 提供一个数组类型解析器(用于生成List<List<E>>)
    _jsonHolderListListFactory["List<${T.toString()}>"] = provideListListCreator;

    // 入值
    this._innerMap = json;
    return this as T;
  }

  /// 获取实际key对应的的值
  F getValue<F>(String key) {
    if (_innerMap != null) {
      //结果值
      F result;

      //此时,可能map中存储的某些字段还是 map 类型,而我们需要的应该是实体对象类型,一因此需要作出判断
      var temp = _innerMap[key];

      //如果 temp 类型 和 F 需要的类型一模一样,则直接返回
      if (temp.runtimeType.toString() == F.toString()) {
        return temp;
      }

      // 针对map类型(一个bean类型)
      if (temp is Map && !RegExp(r"^((Map)|(Map<.+,.+>))$").hasMatch(F.toString())) {
        // 如果map中对应值为 map 类型,但需要的类型非 map,则需要进行转换
        result = _jsonHolderFactory[F.toString()](temp) as F;
      } else if (temp is List && RegExp(r"^List<(.*)>$").hasMatch(F.toString())) {
        // 针对List类型(数组集合类型):没有泛型存在则直接返回查到的结果
        result = getListInner(temp, F.toString());
      } else {
        //其他情况,说明需要的值和后台返回有出入,此时需要进行类型转换
        result = _convent(temp, F.toString());
      }

      //判断是否需要缓存
      if (isCacheMode) {
        _innerMap[key] = result;
      }

      return result;
    } else {
      throw Exception("Before getting the member value, call the 'fromJson' method once");
    }
  }

  ///由于List泛型的存在,在生成列表时,比较麻烦,可能会有嵌套泛型存在
  I getListInner<I>(List array, String type) {
    I result;
    var innerType = RegExp(r"^List<(.*)>$").firstMatch(type).group(1);

    //先判断类型,赋值result,防止空列表情况出现(空列表应该看作 List处理,而不是null)
    bool isRecursive = false;
    if (RegExp(r"^List<(.*)>$").hasMatch(innerType)) {
      isRecursive = true;
      result = _jsonHolderListListFactory[innerType]() as I;
    } else {
      result = _jsonHolderListFactory[innerType]() as I;
    }

    //针对 item 进行处理
    for (var item in array) {
      if (result is List) {
        if (["Object", "int", "double", "num", "bool", "String", "dynamic"].contains(innerType)) {
          //如果泛型为基础类型/动态类型,则返回自身
          result.add(_convent(item, innerType));
        } else if (isRecursive) {
          //如果泛型嵌套,则需要递归调用(此时item肯定还是List类型)
          result.add(getListInner(item, innerType));
        } else {
          //除此以外,应该就是bean类型,此时 item 应该为map类型
          if(item is Map && item.keys.length ==0){
            result.add(_jsonHolderFactory[innerType](<String,dynamic>{}));
          }else{
            // 放置出现item为 : {} ,的情况,此时map的类型变成了 Map<dynamic,dynamic>
            result.add(_jsonHolderFactory[innerType](item));
          }
        }
      }
    }

    return result;
  }

  /// 代理设置目标值
  void setValue(String key, dynamic value) {
    if (_innerMap != null) {
      _innerMap[key] = value;
    } else {
      throw Exception("Before getting the member value, call the 'fromJson' method once");
    }
  }

  ///子类需要提供一下自身的生成器
  JsonHolderImpl<T> provideCreator(Map<String, dynamic> json);

  ///子类需要提供一下自身的生成器
  List provideListCreator();

  ///子类需要提供一下自身的生成器
  List provideListListCreator();

  /// toJson 生成的字符串,并非是 json 格式,如果需要json 格式字符串,需要调用 [dart:convert] 包中 json.encode(obj)
  @override
  String toString() {
    return _innerMap.toString();
  }
}
