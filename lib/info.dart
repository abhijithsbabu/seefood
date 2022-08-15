import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Infopage extends StatelessWidget {
  final List<List<String>> nutri;

  const Infopage({required this.nutri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              nutri[0].toString().substring(1, nutri[0].toString().length - 1)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nutri[1].toString().substring(1, 13)),
                Text(nutri[1]
                    .toString()
                    .substring(13, nutri[1].toString().length - 1)),
              ],
            ),

            // Calorie
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nutri[2]
                    .toString()
                    .substring(1, nutri[2].toString().length - 4)),
                Text(nutri[2].toString().substring(
                        nutri[2].toString().length - 4,
                        nutri[2].toString().length - 1) +
                    ' ' +
                    nutri[3]
                        .toString()
                        .substring(1, nutri[3].toString().length - 6)),
              ],
            ),
            Text(nutri[4]
                .toString()
                .substring(1, nutri[4].toString().length - 1)),
            //nutrients facts

            print_nutris(nutri)
          ],
        ));
  }
}

Widget print_nutris(List<List<String>> nutri) {
  List<Widget> row = [];
  List<String> temp;

  for (int i = 5; i < nutri.length; i++) {
    temp = nutri[i][0].replaceAll(RegExp(r"\s+"), ",").split(',');
    print(temp);

    temp.length > 3
        ? row.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(temp.sublist(0, temp.length - 3).join(' ')),
              Text(temp[temp.length - 2] + temp[temp.length - 1])
            ],
          ))
        : '';
  }
  return Column(
    children: row,
  );
}
