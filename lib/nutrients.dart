import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tflite/tflite.dart';

class Nutrients extends StatefulWidget {
  final Image img;
  final String imgpath;
  const Nutrients({Key? key, required this.img, required this.imgpath})
      : super(key: key);

  @override
  State<Nutrients> createState() => _NutrientsState();
}

class _NutrientsState extends State<Nutrients> {
  late List _outputs = [
    {'confidence': 0.01, 'index': 1, 'label': ''}
  ];

  late String url;
  late List<String> nutri = [];
  late List<String?> imgurl = [];

  @override
  void initState() {
    _outputs = [
      {'confidence': 0.01, 'index': 1, 'label': ''}
    ];
    super.initState();
    _loadModel().then((value) {
      classifyImage(widget.img, widget.imgpath);
      _getdata().then((value) {
        setState(() {});
      });
      setState(() {});
    });
  }

  _getdata() async {
    url = await extractData(_outputs[0]['label']);
    print(url);
    nutri = await extractNutrient(url);
    imgurl = await getgraph(url);
  }

  _loadModel() async {
    await Tflite.loadModel(
      model: "assets/seefood_NasNetMobileModel.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
    );
  }

  classifyImage(Image image, String path) async {
    var output = await Tflite.runModelOnImage(
      path: path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    setState(() {
      _outputs = output!;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    _outputs.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> final_nutri;
    if (_outputs.isEmpty) {
      _outputs = [
        {'confidence': 0.01, 'index': 1, 'label': ''}
      ];
    }
    String _food = _outputs[0]['label'];
    nutri.length != 0 ? final_nutri = customizelist(nutri) : final_nutri = [];

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Color.fromARGB(255, 89, 148, 250),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                          color: Colors.white),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 140.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _food,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Image.network(imgurl[0].toString()),
                                      Image.network(imgurl[1].toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(final_nutri[1]
                                              .toString()
                                              .substring(1, 13)),
                                          Text(final_nutri[1]
                                              .toString()
                                              .substring(
                                                  13,
                                                  final_nutri[1]
                                                          .toString()
                                                          .length -
                                                      1)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(final_nutri[2]
                                              .toString()
                                              .substring(
                                                  1,
                                                  final_nutri[2]
                                                          .toString()
                                                          .length -
                                                      4)),
                                          Text(final_nutri[2]
                                                  .toString()
                                                  .substring(
                                                      nutri[2]
                                                              .toString()
                                                              .length -
                                                          4,
                                                      nutri[2]
                                                              .toString()
                                                              .length -
                                                          1) +
                                              ' ' +
                                              final_nutri[3]
                                                  .toString()
                                                  .substring(
                                                      1,
                                                      final_nutri[3]
                                                              .toString()
                                                              .length -
                                                          6)),
                                        ],
                                      ),
                                      Text(final_nutri[4].toString().substring(
                                          1,
                                          final_nutri[4].toString().length -
                                              1)),
                                      Container(
                                          height: 160,
                                          child: print_nutris(final_nutri)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 200,
                  top: 100,
                  child: FractionalTranslation(
                    translation: Offset(-0.5, -0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(0, 227, 223, 223),
                            blurRadius: 15.0,
                            // spreadRadius: 10.0,
                          )
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10.0,
                        child: Container(
                          height: 200.0,
                          width: 180.0,
                          child: widget.img,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

Widget print_nutris(List<List<String>> nutri) {
  List<Widget> row = [];
  List<String> temp;

  for (int i = 5; i < nutri.length; i++) {
    temp = nutri[i][0].replaceAll(RegExp(r"\s+"), ",").split(',');
    temp.length > 3
        ? row.add(makeWidget(temp.sublist(0, temp.length - 3).join(' '),
            temp[temp.length - 2] + temp[temp.length - 1]))
        : '';
  }
  return ListView(
    scrollDirection: Axis.horizontal,
    children: row,
  );
}

customizelist(List<String> nutri) {
  nutri.removeLast();
  List<String> temp = [];
  List<List<String>> final_nutri = [];
  for (int i = 0; i < nutri.length; i++) {
    if (nutri[i] != '') {
      temp.add(nutri[i].trim());
      if (temp != []) {}
      final_nutri.add(temp);
    }
    temp = [];
  }
  return final_nutri;
}

Widget makeWidget(String name, String value) {
  return Padding(
    padding: const EdgeInsets.only(right: 12.0),
    child: Container(
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0)),
      child: Card(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 87, 86, 86)),
              borderRadius: BorderRadius.circular(20.0)),
          height: 150.0,
          width: 120.0,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}

Future<String> extractData(String _food) async {
//Getting the response from the targeted url
  final response = await http.Client().get(Uri.parse(
      'https://www.nutritionvalue.org/search.php?food_query=' + _food));
  //Status Code 200 means response has been received successfully
  if (response.statusCode == 200) {
    //Getting the html document from the response
    var document = parser.parse(response.body);
    try {
      //Scraping the first article title
      var responseString1 = document
          .getElementsByClassName('results')[0]
          .children[0]
          .children[1]
          .children[0]
          .getElementsByTagName('a')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList()[0];
      //Converting the extracted titles into string and returning a list of Strings
      return responseString1.toString();
    } catch (e) {
      return 'err';
    }
  } else {
    return '${response.statusCode}';
  }
}

Future<List<String?>> getgraph(String _url) async {
  //Getting the response from the targeted url
  final response_final = await http.Client()
      .get(Uri.parse('https://www.nutritionvalue.org' + _url));

  if (response_final.statusCode == 200) {
    var document_final = parser.parse(response_final.body);
    try {
      var responseString_final = document_final
          .getElementsByTagName('img')
          .where((e) => e.attributes.containsKey('src'))
          .map((e) => e.attributes['src'])
          .toList();
      return responseString_final;
    } catch (e) {
      return ['err'];
    }
  } else {
    return ['${response_final.statusCode}'];
  }
}

Future<List<String>> extractNutrient(String _url) async {
//Getting the response from the targeted url
  final response_final = await http.Client()
      .get(Uri.parse('https://www.nutritionvalue.org' + _url));

  if (response_final.statusCode == 200) {
    var document_final = parser.parse(response_final.body);
    try {
      //NUTRIENTS PAGE
      var responseString_final = document_final
          .getElementById('nutrition-label')!
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children
          .map((e) => e.text.trim())
          .toList();

      return responseString_final;
    } catch (e) {
      return ['err'];
    }
  } else {
    return ['${response_final.statusCode}'];
  }
}
