import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

class Detail extends StatefulWidget {
  final Article article;
  const Detail({Key? key, required this.article}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          CachedNetworkImage(
            imageUrl: widget.article.urlToImage ??
                "https://dummyimage.com/100x100/ffffff/000800&text=No+Image",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: 400,
            height: 250,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 40,
                  child: Center(
                      child: Text(
                    widget.article.title!.substring(0, 1),
                    style: GoogleFonts.lexendDeca(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                child: Text(
                  widget.article.description!,
                  maxLines: 10,
                  style: GoogleFonts.lobster(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 6, 81, 167),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30))),
                  child: widget.article.url == null
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () async {
                            final urL = widget.article.url!;
                            if (await canLaunch(urL)) {
                              await launch(urL);
                            } else {
                              throw "Can't launch $urL";
                            }
                          },
                          child: Text(
                            widget.article.url ?? " ",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 207, 221, 233)),
                            maxLines: 10,
                          ),
                        )),
            ],
          ),
        ]),
      ),
    );
  }
}
