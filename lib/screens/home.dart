import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/article.dart';
import '../services/api_service.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  final String apiKey;
  const Home({Key? key, required this.apiKey}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Services services = Services();
  List<Article> articles = <Article>[];
  String searchTopic = "india";
  final topicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    List<Article> newArticles =
        await services.getArticle(widget.apiKey, topic: "india");
    setState(() {
      articles = newArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: topicController,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 154, 189, 218),
                hintText: "Search news topic here",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Color.fromARGB(255, 93, 121, 134)))),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  List<Article> newArticles = await services.getArticle(
                      widget.apiKey,
                      topic: topicController.text.isEmpty
                          ? "india"
                          : topicController.text);
                  setState(() {
                    searchTopic = topicController.text;
                    topicController.clear();
                    articles = newArticles;
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Center(
          child: articles.isEmpty
              ? const CircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: () async {
                    Completer<void> completer = Completer<void>();
                    List<Article> newArticles = await services
                        .getArticle(widget.apiKey, topic: searchTopic);
                    completer.complete();
                    setState(() {
                      articles = newArticles;
                    });
                    return completer.future;
                  },
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) => ListTile(
                        title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detail(
                                        article: articles[
                                            articles.length - 1 - index],
                                      )));
                        },
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: articles[articles.length - 1 - index]
                                      .urlToImage ??
                                  "https://dummyimage.com/100x100/ffffff/000800&text=No+Image",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 100,
                              height: 100,
                            ),
                            Text(articles[articles.length - 1 - index].title!,
                                style: GoogleFonts.lato(color: Colors.black)),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
        ));
  }
}
