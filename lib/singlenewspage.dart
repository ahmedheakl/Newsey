import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:newsey/newsmodel.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:async_button_builder/async_button_builder.dart';

const Color backgroundColor = Color.fromARGB(255, 171, 246, 223);
const Color foregroundColor = Color.fromARGB(255, 28, 131, 93);
const Color containerColor = Colors.white30;
const Color redColor = Color.fromARGB(255, 227, 46, 82);

int getYear(String? publishedAt) {
  DateTime obj = DateTime.parse(publishedAt!);
  return obj.year;
}

int getMonth(String? publishedAt) {
  DateTime obj = DateTime.parse(publishedAt!);
  return obj.month;
}

class SingleNewsPage extends StatelessWidget {
  News news;
  SingleNewsPage(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
                padding: EdgeInsets.only(right: 10, left: 55),
                child: CircleAvatar(
                    backgroundColor: redColor,
                    child: Icon(Icons.newspaper_rounded,
                        size: 25, color: Colors.white))),
            Text("NEWSEY",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ],
        )),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_rounded,
                size: 30, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: containerColor,
        child: Column(children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, right: 15, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.title!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Wrap(
                            children: [
                              Text("BY ${news.author!.toUpperCase()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(news.source!,
                                    style: const TextStyle(
                                        color: foregroundColor)),
                              ),
                              Text(
                                  "${getMonth(news.publishedAt)}.${getYear(news.publishedAt)}",
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(218, 149, 148, 148)))
                            ],
                          )),
                    ],
                  )),
              Stack(
                children: <Widget>[
                  const Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 100, bottom: 100),
                          child: CircularProgressIndicator())),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: news.urlImage!,
                      placeholderFit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(news.descp!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "open sans",
                              fontWeight: FontWeight.bold)))),
            ],
          )),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50, bottom: 5),
            width: 200,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [redColor, Color.fromARGB(255, 235, 37, 83)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
            ),
            child: AsyncButtonBuilder(
              loadingWidget: const Center(child: CircularProgressIndicator()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Read More',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                  Icon(
                    Icons.play_circle_outline,
                    size: 25,
                    color: Colors.white,
                  )
                ],
              ),
              onPressed: () async {
                if (await canLaunchUrlString(news.url!)) {
                  await launchUrlString(news.url!);
                } else {
                  // can't launch url, there is some error
                  throw "Could not launch ${news.url!}";
                }
              },
              builder: (context, child, callback, _) {
                return TextButton(
                  onPressed: callback,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: child,
                );
              },
            ),
          )
        ]),
      ),
    ));
  }
}
