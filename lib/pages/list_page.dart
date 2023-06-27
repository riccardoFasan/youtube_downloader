import 'package:flutter/material.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class ListPage extends StatelessWidget {
  final Widget _barContent;
  final Widget _columnContent;

  const ListPage({
    super.key,
    required barContent,
    required columnContent,
  })  : _barContent = barContent,
        _columnContent = columnContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _barContent,
      ),
      bottomNavigationBar: Navigation(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _columnContent,
          )
        ],
      ),
    );
  }
}
