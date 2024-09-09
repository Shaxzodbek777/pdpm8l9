import 'package:flutter/material.dart';

import '../model.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.input}) : super(key: key);

  final Post input;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Detail Page",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.input.title,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.input.body.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.input.userId.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
        )
    );
  }
}