import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsey/newsmodel.dart';
import 'package:newsey/singlenewspage.dart';

const Color redColor = Color.fromARGB(255, 227, 46, 82);

int getYear(String? publishedAt) {
  DateTime obj = DateTime.parse(publishedAt!);
  return obj.year;
}

int getMonth(String? publishedAt) {
  DateTime obj = DateTime.parse(publishedAt!);
  return obj.month;
}

String constructURL(String keyword) {
  return "https://newsapi.org/v2/everything?q=$keyword&from=2022-09-04&sortBy=popularity&apiKey=8c1ec7aedb814a9d8b8d8d70b18f84ed";
}

void main() {
  runApp(MaterialApp(home: NewsPage()));
}

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<News> newsList = [];
  @override
  void initState() {
    super.initState();
    fetchNewsHelper();
  }

  fetchNewsHelper({String keyword = "Apple"}) async {
    await fetchNews(keyword: keyword);
  }

  fetchNews({String keyword = "Apple"}) async {
    setState(() {
      newsList = [];
    });
    http.Response response = await http.get(Uri.parse(constructURL(keyword)));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Map<String, dynamic> dataMap = jsonDecode(response.body);
      List<dynamic> data = dataMap["articles"];

      setState(() {
        for (int i = 0; i < data.length; ++i) {
          News news = News.json(data[i]);

          newsList.add(news);
        }
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  TextEditingController keywordController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                      backgroundColor: redColor,
                      child: Icon(Icons.newspaper_rounded,
                          size: 25, color: Colors.white))),
              Text("NEWSEY",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
            ],
          )),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      body: newsList.isEmpty
          ? Container(
              color: Colors.white,
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formkey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      fetchNewsHelper(
                                          keyword: keywordController.text);
                                    });
                                  },
                                  child: const Icon(
                                      Icons.arrow_circle_right_rounded,
                                      size: 30,
                                      color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.5)),
                              prefixIcon:
                                  const Icon(Icons.search_rounded, size: 25),
                              hintText: "Search by a word ..."),
                          controller: keywordController,
                        ))),
                const Divider(
                  color: Colors.black,
                ),
                const Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator())),
              ]))
          : Container(
              color: Colors.white,
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formkey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      fetchNewsHelper(
                                          keyword: keywordController.text);
                                    });
                                  },
                                  child: const Icon(
                                      Icons.arrow_circle_right_rounded,
                                      size: 30,
                                      color: Colors.green)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.5)),
                              prefixIcon:
                                  const Icon(Icons.search_rounded, size: 25),
                              hintText: "Search by a word ..."),
                          controller: keywordController,
                        ))),
                const Divider(
                  color: Colors.black,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingleNewsPage(newsList[index])));
                        },
                        child: Center(
                            child: Card(
                                child: ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(newsList[index].urlImage!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          ),
                          title: Text(newsList[index].title!),
                          subtitle: Text(
                              "${getMonth(newsList[index].publishedAt)}/${getYear(newsList[index].publishedAt)}"),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            size: 30,
                            color: Colors.black,
                          ),
                        ))));
                  },
                ))
              ]),
            ),
    ));
  }
}
