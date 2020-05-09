import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frstapp/scr.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstPage(),
  ));
}

class FirstPage extends StatelessWidget {
  var _categoryNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: new Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
              ),
              Image.asset(
                'images/photobay.png',
                width: 200.0,
                height: 200.0,
              ),
              new ListTile(
                title: new TextFormField(
                  controller: _categoryNameController,
                  decoration: new InputDecoration(
                      labelText: 'Enter the category',
                      hintText: 'eg: dogs,bikes,cats...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              new ListTile(
                title: new Material(
                    color: Colors.lightBlue,
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    child: new MaterialButton(
                      height: 47.5,
                      onPressed: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context){
                            return new SecondPage(category: _categoryNameController.text,);
                          })

                        );
                      },
                      child: Text(
                        'search',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold,
                        color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class SecondPage extends StatefulWidget{
  String category;
  SecondPage({this.category});
  @override
  _secondPageState createState() => _secondPageState();
}
class _secondPageState extends State<SecondPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Photo Bay',
        style: TextStyle(color:Colors.black),),
        centerTitle:true,
    ),
      body: new FutureBuilder(
        future:getpics(widg et.category),

          builder: (context,snapShot){
          Map data = snapShot.data;
          if(snapShot.hasError){
            print(snapShot.error);
            return Text('Failed to get response from the server',
            style: TextStyle(color:Colors.red,
            fontSize:22.0),);
          }
          else if(snapShot.hasData){
            return new Center(
              child: new ListView.builder(
                itemCount: data.length,
                  itemBuilder: (context,index){
                  return new Column(
                    children: <Widget>[

                      new Container(
                        child: new InkWell(
                          onTap: (){},
                          child: new Image.network(
                            '${data['hits'][index]['largeImageURL']}'

                          ),
                        ),
                      ),
                      new Padding(padding: const EdgeInsets.all(5.0)),
                    ],
                  );
                  }),
            );
          }
          else if(!snapShot.hasData){
            return new Center(child: CircularProgressIndicator(),);
          }
          }),
    );
  }

}
Future<Map> getpics(String category) async{
  String url='https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&pretty=true';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}