import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import '../model.dart';
import '../service/http.dart';
import '../service/log.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      isLoading = false;
      if (response != null) {
        items = Network.parsePostList(response);
      } else {
        items = [];
      }
    });
  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    setState(() {
      if (response != null) {
        _apiPostList();
      } else {}
      isLoading = false;
    });
  }

  Future<void> createData() async {
    const url = 'http://jsonplaceholder.typicode.com/posts';

    final newData = {
      'title': 'Yangi sarlavha',
      'body': 'Yangi matn',
      'userId': 1,
    };
    setState(() {
      isLoading = true;
    });
    final response = await Dio().post(url, data: newData);

    setState(() {
      if (response.statusCode == 201) {
        LogService.i('Malumot yaratildi');
      } else {
        LogService.e('Malumot yaratishda xatolik: ${response.statusCode}');
      }
      isLoading = false;
    });
  }

  void _apiPostUpdate(Post post) async {
    setState(() {
      isLoading = true;
    });

    final url = 'http://jsonplaceholder.typicode.com/posts/${post.id}';
    final response = await put(
      Uri.parse(url),
      body: json.encode(post.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      if (response.statusCode == 200) {
        LogService.i("data Updated");
      } else {
        LogService.e("Update error");
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("setState"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return itemOfPost(items[index]);
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          createData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return InkWell(
      onTap: () {
        _openDetails(post);
      },
      child: Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {},
            ),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  _apiPostUpdate(post);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: "Update",
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {},
            ),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  _apiPostDelete(post);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: "Delete",
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title.toUpperCase()),
                const SizedBox(
                  height: 5,
                ),
                Text(post.body),
              ],
            ),
          )),
    );
  }

  Future _openDetails(Post post) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage(
        input: post,
        key: null,
      );
    }));
  }
}