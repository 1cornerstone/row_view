
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

 class RowSliverGridTileLayout extends SliverGridLayout {

   const RowSliverGridTileLayout({
     required this.mainAxisCount,
     required this.crossAxisStride,
     required this.mainAxisStride,
     required this.childCrossAxisExtent,
     required this.childMainAxisExtent,
   });

   /// The number of children in the main axis
   final int mainAxisCount;
   /// The number of pixels from the leading edge of one tile to the leading edge of the next tile in the cross axis.
   /// This is just tile size + spacing specified
   final double mainAxisStride;
   /// The number of pixels from the leading edge of one tile to the leading edge of the next tile in the cross axis.
   /// This is just tile size + spacing specified
   final double crossAxisStride;

   final double childCrossAxisExtent;
   final double childMainAxisExtent;

  @override
  double computeMaxScrollOffset(int childCount) {

    if(childCount <= 0){
     return 0.0;
    }

    /// Calculate number the column for the grid
    /// assume childCount is 30 and number of item per column is row 3,
    /// ((30 -1 ) ~/ 3) +1
    /// (29 ~/ 3)
    /// 9 +1 = 10
    final int crossAxisCount = (( childCount -1) ~/ mainAxisCount) + 1;

    /// Assume height of each widget is 200 and cross spacing to be 10
    /// CrossAxisStride is (height + crossSpacing)
    /// This is like calculating actual size - absolute size
    final double crossAxisSpacing = crossAxisStride -  childCrossAxisExtent;

    /// return 210 * 3 - 10
    return crossAxisStride * crossAxisCount - crossAxisSpacing;
  }


  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final double crossAxisStart = (index % mainAxisCount) * mainAxisStride;
    return SliverGridGeometry(
        scrollOffset: (index ~/ mainAxisCount) * mainAxisStride,
        crossAxisOffset: crossAxisStart,
        mainAxisExtent: childMainAxisExtent,
        crossAxisExtent: childCrossAxisExtent);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
   if(crossAxisStride > 0.0) {
     final int crossAxisCount = (scrollOffset / crossAxisStride).ceil();
     return math.max(0, mainAxisCount * crossAxisCount - 1);
   }
   return 0;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return crossAxisStride > precisionErrorTolerance ? mainAxisCount * ( scrollOffset ~/ crossAxisStride)  : 0;
  }

}