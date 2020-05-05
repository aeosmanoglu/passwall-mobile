import 'package:Passwall/utils/objects.dart';
import 'package:Passwall/widgets/detail_widget.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Login credential;
  DetailPage(this.credential);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DetailWidget(widget.credential),
    );
  }
}
