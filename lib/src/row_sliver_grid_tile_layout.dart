

import 'package:flutter/rendering.dart';

 class RowSliverGridTileLayout extends SliverGridLayout {

  @override
  double computeMaxScrollOffset(int childCount) {
    if(childCount <= 0){
     return 0.0;
    }
    throw UnimplementedError();
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // TODO: implement getGeometryForChildIndex
    throw UnimplementedError();
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMaxChildIndexForScrollOffset
    throw UnimplementedError();
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // TODO: implement getMinChildIndexForScrollOffset
    throw UnimplementedError();
  }

}