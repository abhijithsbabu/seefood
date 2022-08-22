import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class nutrients extends StatefulWidget {
  const nutrients({Key? key, Image? img, String? name}) : super(key: key);

  @override
  State<nutrients> createState() => _nutrientsState();
}

class _nutrientsState extends State<nutrients> {
  @override
  Widget build(BuildContext context) {
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
                      // color: Colors.white,
                      child: Stack(
                        children: [
                          // Positioned(
                          //   left: 100,
                          //   top: 60,
                          //   child: FractionalTranslation(
                          //     translation: Offset(-0.5, -0.5),
                          //     child: CircleAvatar(
                          //       radius: 80.0,
                          //       backgroundColor:
                          //           Color.fromARGB(255, 255, 211, 80),
                          //     ),
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 80.0,
                          //       backgroundColor:
                          //           Color.fromARGB(255, 255, 211, 80),
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 140.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Veg Biriyani",
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 250.0, left: 30.0),
                                  child: Container(
                                    height: 160,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        makeWidget("name", "value"),
                                        makeWidget("name", "value"),
                                        makeWidget("name", "value"),
                                        makeWidget("name", "value")
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
                          height: 170.0,
                          width: 180.0,
                          child: Icon(Icons.image,
                              color: Colors.black, size: 50.0),
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
                    '20 g',
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
