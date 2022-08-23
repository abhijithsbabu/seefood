import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
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
    final List<List<String>> finalNutri;
    late String food;
    if (_outputs.isEmpty) {
      _outputs = [
        {'confidence': 0.01, 'index': 1, 'label': ''}
      ];
    }
    setState(() {
      food = _outputs[0]['label'];
    });
    nutri.isNotEmpty ? finalNutri = customizelist(nutri) : finalNutri = [];
    print(food);
    if (nutri.isEmpty || _outputs[0]['label'] == '' || imgurl.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
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
            backgroundColor: const Color.fromARGB(255, 89, 148, 250),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                          color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 140.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      food,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  color: Colors.white,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Image.network(imgurl[0].toString()),
                                      Image.network(imgurl[1].toString())
                                    ],
                                  ),
                                ),
                                Container(
                                  color: const Color(0xfff5f5f5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 8.0, right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 15, 8, 15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        finalNutri[1]
                                                            .toString()
                                                            .substring(1, 13),
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                    Text(
                                                        finalNutri[1]
                                                            .toString()
                                                            .substring(
                                                                13,
                                                                finalNutri[1]
                                                                        .toString()
                                                                        .length -
                                                                    1),
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        finalNutri[2]
                                                            .toString()
                                                            .substring(1, 19),
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                    Text(
                                                        '${finalNutri[2].toString().substring(19, finalNutri[2].toString().length - 1)} ${finalNutri[3].toString().substring(1, finalNutri[3].toString().length - 6)}',
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          finalNutri[4].toString().substring(
                                              1,
                                              finalNutri[4].toString().length -
                                                  1),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        print_nutris(finalNutri)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 200,
                    top: 100,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, -0.5),
                      child: Container(
                        decoration: const BoxDecoration(
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
                          child: SizedBox(
                            height: 180.0,
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
}

Widget print_nutris(List<List<String>> nutri) {
  List<Widget> row = [];
  List<Widget> row2 = [];
  List<String> temp;

  for (int i = 5; i < nutri.length; i++) {
    temp = nutri[i][0].replaceAll(RegExp(r"\s+"), ",").split(',');
    temp.length > 3
        ? row.add(makeWidget(temp.sublist(0, temp.length - 3).join(' '),
            temp[temp.length - 2] + temp[temp.length - 1]))
        : '';
  }
  for (int i = 0; i < row.length; i = i + 2) {
    row2.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [row[i], row[i + 1]],
    ));
    row2.add(const SizedBox(height: 10));
  }
  if (row.length % 2 != 0) {
    row2.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [row[row.length - 1]],
    ));
  }

  return Column(
    children: row2,
  );
}

customizelist(List<String> nutri) {
  nutri.removeLast();
  List<String> temp = [];
  List<List<String>> finalNutri = [];
  for (int i = 0; i < nutri.length; i++) {
    if (nutri[i] != '') {
      temp.add(nutri[i].trim());
      if (temp != []) {}
      finalNutri.add(temp);
    }
    temp = [];
  }
  return finalNutri;
}

Widget makeWidget(String name, String value) {
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(10.0)),
      width: 170,
      height: 150,
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ]),
    ),
  );
}

Future<String> extractData(String food) async {
//Getting the response from the targeted url
  final response = await http.Client().get(Uri.parse(
      'https://www.nutritionvalue.org/search.php?food_query=' + food));
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

Future<List<String?>> getgraph(String url) async {
  //Getting the response from the targeted url
  final responseFinal = await http.Client()
      .get(Uri.parse('https://www.nutritionvalue.org' + url));

  if (responseFinal.statusCode == 200) {
    var documentFinal = parser.parse(responseFinal.body);
    try {
      var responseStringFinal = documentFinal
          .getElementsByTagName('img')
          .where((e) => e.attributes.containsKey('src'))
          .map((e) => e.attributes['src'])
          .toList();
      return responseStringFinal;
    } catch (e) {
      return ['err'];
    }
  } else {
    return ['${responseFinal.statusCode}'];
  }
}

Future<List<String>> extractNutrient(String url) async {
//Getting the response from the targeted url
  final responseFinal = await http.Client()
      .get(Uri.parse('https://www.nutritionvalue.org' + url));

  if (responseFinal.statusCode == 200) {
    var documentFinal = parser.parse(responseFinal.body);
    try {
      //NUTRIENTS PAGE
      var responseStringFinal = documentFinal
          .getElementById('nutrition-label')!
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children
          .map((e) => e.text.trim())
          .toList();

      return responseStringFinal;
    } catch (e) {
      return ['err'];
    }
  } else {
    return ['${responseFinal.statusCode}'];
  }
}
