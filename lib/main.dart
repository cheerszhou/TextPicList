import 'package:flutter/material.dart';
import 'package:myself_project/custom_type_list.dart';
import 'rich_text_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Text Pic List'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String? title;
  @override
  _MyHomePageState createState() => _MyHomePageState();

  MyHomePage({this.title});
}

class _MyHomePageState extends State<MyHomePage> {

  RichTextList<CustomTypeList> textList = RichTextList()..initial();
  int currentPosition = 0;
  late TextEditingController currentController;
  final String imageOne = "https://img2.baidu.com/it/u=2376230547,617493641&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500";
  final String imageTwo = "http://pic1.win4000.com/wallpaper/c/57b67b5ef372f.jpg";
  final String imageThree = "http://pic1.win4000.com/wallpaper/8/548aab16ceff3.jpg?down";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget?.title??""),
      ),
      body: Container(
        child:ListView.builder(
          itemCount: textList.size,
          itemBuilder: (BuildContext context, int position) {
            textList.list[position].key??=CustomTypeList();
            if (textList.list[position].key.flag == TypeFlag.text) {
              return TextItem(position, textList.list[position], (index, controller){
                currentPosition = index;
                currentController = controller;
              });
            } else if (textList.list[position].key.flag == TypeFlag.image) {
              return Stack(
                children: <Widget>[
                  Container(
                    child: Image.network(textList.list[position].key.imageUrl),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        icon: Icon(Icons.cancel),
                        iconSize: 35,
                        color: Colors.red,
                        onPressed: (){
                          textList.remove(position);
                          setState(() {

                          });
                        }),
                  ),
                ],
              );
            }
          },
          scrollDirection: Axis.vertical,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "single",
            onPressed: (){
              if(currentController == null) return;
              textList.insertOne(currentPosition, getBeforeText(currentController)!, getSelectText(currentController)!,
                  getAfterText(currentController)!, CustomTypeList(flag: TypeFlag.image,
                      imageUrl: imageOne));
              setState(() {
              });
            },
            tooltip: '插入',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: "multi",
            onPressed: (){
              if(currentController == null) return;
              textList.insert(currentPosition,
                  getBeforeText(currentController)!,
                  getSelectText(currentController)!,
                  getAfterText(currentController)!,
                  [CustomTypeList(flag: TypeFlag.image, imageUrl: imageTwo),
                  CustomTypeList(flag: TypeFlag.image, imageUrl: imageThree)]);
              setState(() {
              });
            },
            tooltip: '插入',
            child: Icon(Icons.add_to_photos),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  String? getAfterText(TextEditingController controller) {
    return controller?.selection?.textAfter(controller.text);
  }

  String? getSelectText(TextEditingController controller) {
    return controller?.selection?.textInside(controller.text);
  }

  String? getBeforeText(TextEditingController controller) {
    return controller?.selection?.textBefore(controller.text);
  }
}


class TextItem extends StatelessWidget {
  final int index;
  final TextEntry<CustomTypeList, String> _entry;
  final Function focusCallBack;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  TextItem(this.index, this._entry, this.focusCallBack){
    _controller.text = _entry.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: new TextField(
        controller: _controller,
        onChanged: (text) => _entry.value = text,
        keyboardType: TextInputType.multiline,
        textDirection: TextDirection.ltr,
        maxLines: null,
        autofocus: index == 0 ? true : false,
        focusNode: _focusNode..addListener(() {
          if (_focusNode.hasFocus) {
            focusCallBack(index, _controller);
            print("当前选择的是:${index}");
          }
        }),
        decoration: InputDecoration(
          hintText: index == 0 ? "在这里开始..." : "在这里继续...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}


