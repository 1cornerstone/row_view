import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:row_view/src/row_view_sliver_grid_tile_layout.dart';





class RowView extends BoxScrollView {

  final RowViewSliverGridDelegateWithFixedMainAxisCount gridDelegate;
  final SliverChildDelegate childrenDelegate;

  RowView({
    super.key,
    super.controller,
    super.primary,
    super.physics,
    super.padding,
    super.scrollDirection = Axis.horizontal,
    required this.gridDelegate,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? itemCount,
  }) : childrenDelegate = RowViewSliverChildBuilderDelegate(
      itemBuilder,
    childCount: itemCount
  );

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverGrid(
        delegate: childrenDelegate,
        gridDelegate: gridDelegate);
  }
}


class RowViewSliverChildBuilderDelegate extends SliverChildDelegate{
  final int? childCount;
  final NullableIndexedWidgetBuilder builder;
  RowViewSliverChildBuilderDelegate(this.builder, {this.childCount});

  @override
  int? get estimatedChildCount => childCount;

  @override
  @pragma('vm:notify-debugger-on-exception')
  Widget? build(BuildContext context, int index) {
    /// Check if index is not less than 0 and not greater than childCount
    if(index < 0 || (childCount == null  && index >= childCount!)){
      return null;
    }

    Widget? child;

    try{
      /// return the widget of the index
      child = builder(context, index);
    }catch(exception, stk){
      child = _createErrorWidget(exception, stk);
    }

    if(child == null) return null;

    final Key? key = child.key != null ? ValueKey(child.key) : null;
    return KeyedSubtree(key: key, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) => true;

}

class RowViewSliverGridDelegateWithFixedMainAxisCount extends SliverGridDelegate{

  RowViewSliverGridDelegateWithFixedMainAxisCount({
    this.crossAxisExtent,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing =0.0,
    required this.mainAxisCount,
    required this.mainAxisHeight,
  });

  /// The number of tiles in main axis
  final int mainAxisCount;
  /// The number of logical pixel between each child along cross axis
  final double crossAxisSpacing;
  /// The number of logical pixel between each child along main axis
  final double mainAxisSpacing;

  final double? crossAxisExtent;

  /// main axis height
  final double mainAxisHeight;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    /// Validate if main axis height is set
    assert(mainAxisHeight > 0, 'main axis height error');
    /// Calculate the actual usable space on main axis(y-axis)
    final double usableMainAxisExtent = math.max(
      0.0,
      mainAxisHeight - mainAxisSpacing * (mainAxisCount - 1),
    );
    /// Divide the usableMainAxisExtent by number of tiles on main axis
    final double childMainAxisExtent = usableMainAxisExtent / mainAxisCount;
    /// use the passed crossAxisExtent value or main axis value
    final double childCrossAxisExtent = crossAxisExtent ?? childMainAxisExtent;
    return RowSliverGridTileLayout(
      mainAxisCount: mainAxisCount,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing, ///
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      childCrossAxisExtent: childCrossAxisExtent,
      childMainAxisExtent: childMainAxisExtent,
    );
  }

  /// subject to change only if any data change
  @override
  bool shouldRelayout(RowViewSliverGridDelegateWithFixedMainAxisCount oldDelegate) {
    return oldDelegate.crossAxisSpacing != crossAxisSpacing
          || oldDelegate.mainAxisSpacing != mainAxisSpacing
          // || oldDelegate.aspectRatio != crossAxisSpacing
          || oldDelegate.mainAxisCount != mainAxisCount;
  }
}


Widget _createErrorWidget(Object exception, StackTrace stackTrace) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stackTrace,
    library: 'widgets library',
    context: ErrorDescription('building'),
  );
  FlutterError.reportError(details);
  return ErrorWidget.builder(details);
}


