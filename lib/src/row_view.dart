import 'package:flutter/cupertino.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:row_view/src/row_sliver_grid_tile_layout.dart';

//
// class RowView extends StatefulWidget {
//
//   final ScrollPhysics? physics;
//   final ScrollController? controller;
//   final double mainAxisSpacing;
//   final double crossAxisSpacing;
//   final String? restorationId;
//   final ScrollController? scrollController;
//   final List<Widget> children;
//
//   const RowView({
//     this.controller,
//     super.key, this.physics,
//     this.children = const [],
//     this.mainAxisSpacing = 0.0,
//     this.crossAxisSpacing = 0.0,
//     this.scrollController,
//     this.restorationId,
//   });
//
//   @override
//   State<RowView> createState() => _RowViewState();
// }
//
// class _RowViewState extends State<RowView> {
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return LayoutBuilder(
//         builder: (builder, constraint){
//           return CustomMultiChildLayout(
//               delegate: RowViewMultiChildLayoutDelegate(
//                 actualWidth: MediaQuery.sizeOf(context).width,
//                 constraint: constraint
//               ),
//               children: widget.children.map((child) => LayoutId(
//                   id: UniqueKey(),
//                   child: child)).toList()
//           );
//         });
//   }
// }
//
//
// // get remaining width value
// // calculate width occupied by widget
// // Calculate width to occupied by child using ((itemPerAxis specified || ) * (get padding left + child width))
// // render
//
// class RowViewMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
//   // constraint for child to occupied,
//   final BoxConstraints constraint;
//   final double actualWidth;
//   RowViewMultiChildLayoutDelegate({ required this.actualWidth, required this.constraint});
//
//   // @override
//   // Size getSize(BoxConstraints constraints) {
//   //   // TODO: implement getSize
//   //   return super.getSize(constraints);
//   // }
//
//   @override
//   void performLayout(Size size) {
//     /// This [size] gives me the detail of box constraint i am to work with.
//   }
//
//   @override
//   bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
//     // TODO: implement shouldRelayout
//     throw UnimplementedError();
//   }
// }
//
//
//

class RowView extends BoxScrollView {

  final SliverGridDelegate gridDelegate;
  final SliverChildDelegate childrenDelegate;
  final int mainAxisCount;

  RowView({
    super.key,
    super.controller,
    super.primary,
    super.physics,
    super.padding,
    super.scrollDirection = Axis.horizontal,
    required this.mainAxisCount,
    required this.gridDelegate,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? itemCount,
  }) : childrenDelegate = RowSliverChildBuilderDelegate(
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



class RowSliverChildBuilderDelegate extends SliverChildDelegate{
  final int? childCount;
  final NullableIndexedWidgetBuilder builder;
  RowSliverChildBuilderDelegate(this.builder, {this.childCount});

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


class RowSliverGridDelegateWithFixedMainAxisCount extends SliverGridDelegate{
  final int mainAxisCount;
  final double aspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  RowSliverGridDelegateWithFixedMainAxisCount({
    this.aspectRatio =1 , this.crossAxisSpacing = 0, this.mainAxisSpacing =0,
    required this.mainAxisCount});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    //
    return RowSliverGridTileLayout();
  }

  /// subject to change only if any data change
  @override
  bool shouldRelayout(RowSliverGridDelegateWithFixedMainAxisCount oldDelegate) {
    return oldDelegate.crossAxisSpacing != crossAxisSpacing
          || oldDelegate.mainAxisSpacing != mainAxisSpacing
          || oldDelegate.aspectRatio != crossAxisSpacing
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


