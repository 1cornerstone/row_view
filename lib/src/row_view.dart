

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

enum Layout{
  single_row,
  multiple_row
}

class RowView extends StatefulWidget {

  final ScrollPhysics? physics;
  final ScrollController? controller;
  final double mainAxisSpacing;
  final String? restorationId;
  final ScrollController? scrollController;
  final Layout layout;

  const RowView({
    super.key,
  this.physics,
    this.scrollController,
  this.mainAxisSpacing = 0.0,
  this.restorationId,
  List<Widget> children = const [],
  this.controller,
  }):
     layout = Layout.single_row;

  const RowView.builder({
    super.key, this.physics,
    required int rowCount,
    this.mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    this.scrollController,
    this.restorationId,
    required NullableIndexedWidgetBuilder itemBuilder, this.controller,
  }): assert(rowCount > 1, 'Row count must be greater than 1 or use RowView'),
   layout = Layout.multiple_row
  ;

  @override
  State<RowView> createState() => _RowViewState();
}

class _RowViewState extends State<RowView> {
  @override
  Widget build(BuildContext context) {
    return  widget.layout == Layout.single_row ?  const SingleRowView() : Container();
  }
}


class SingleRowView extends ScrollView{

  const SingleRowView({super.key});

  @override
  List<Widget> buildSlivers(BuildContext context) {
    // TODO: implement buildSlivers
    throw UnimplementedError();
  }
}









