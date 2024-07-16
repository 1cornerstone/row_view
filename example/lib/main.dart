import 'package:flutter/material.dart';
import 'package:row_view/row_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body:   Center(
          child: SizedBox(
            height: 400,
            child: RowView(
                itemCount: 30,
                gridDelegate: RowViewSliverGridDelegateWithFixedMainAxisCount(
                    mainAxisCount: 3, // number of items in each row
                    mainAxisSpacing: 3.0, // spacing between rows
                    crossAxisSpacing: 3.0, // spacing between columns
                    mainAxisHeight: 400
                ),
                itemBuilder: (itemBuilder, index){
                  return Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      )
      // const CustomMultiChildLayoutApp()
    );
  }
}


//Size(393.0, 737.0)

/// Flutter code sample for [CustomMultiChildLayout].
class CustomMultiChildLayoutApp extends StatelessWidget {
  const CustomMultiChildLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Row(
          children: [
             Container(
               width: 100,
             ),
            SizedBox(
              width: 293,
                height: 300,
                child: const CustomMultiChildLayoutExample())
          ],
        ),
      ),
    );
  }
}

/// Lays out the children in a cascade, where the top corner of the next child
/// is a little above (`overlap`) the lower end corner of the previous child.
///
/// Will relayout if the text direction changes.
class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate({
    required this.colors,
    required this.overlap,
    required this.textDirection,
  });

  final Map<String, Color> colors;
  final double overlap;
  final TextDirection textDirection;

  // Perform layout will be called when re-layout is needed.
  @override
  void performLayout(Size size) {
    print(size);
    final double columnWidth = size.width / colors.length;
    // Offset childPosition = Offset.zero;
    // switch (textDirection) {
    //   case TextDirection.rtl:
    //     childPosition += Offset(size.width, 0);
    //   case TextDirection.ltr:
    //     break;
    // }

    // for (final String color in colors.keys) {
    //   // layoutChild must be called exactly once for each child.
    //   final Size currentSize = layoutChild(
    //     color,
    //     BoxConstraints(maxHeight: size.height, maxWidth: columnWidth),
    //   );
    //   // positionChild must be called to change the position of a child from
    //   // what it was in the previous layout. Each child starts at (0, 0) for the
    //   // first layout.
    //   switch (textDirection) {
    //     case TextDirection.rtl:
    //       positionChild(color, childPosition - Offset(currentSize.width, 0));
    //       childPosition +=
    //           Offset(-currentSize.width, currentSize.height - overlap);
    //     case TextDirection.ltr:
    //       positionChild(color, childPosition);
    //       childPosition +=
    //           Offset(currentSize.width, currentSize.height - overlap);
    //   }
    // }
  }

  // shouldRelayout is called to see if the delegate has changed and requires a
  // layout to occur. Should only return true if the delegate state itself
  // changes: changes in the CustomMultiChildLayout attributes will
  // automatically cause a relayout, like any other widget.
  @override
  bool shouldRelayout(_CascadeLayoutDelegate oldDelegate) {
    return false;
      // oldDelegate.textDirection != textDirection ||
      //   oldDelegate.overlap != overlap;
  }
}

class CustomMultiChildLayoutExample extends StatelessWidget {
  const CustomMultiChildLayoutExample({super.key});

  static const Map<String, Color> _colors = <String, Color>{
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Cyan': Colors.cyan,
  };

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _CascadeLayoutDelegate(
        colors: _colors,
        overlap: 10.0,
        textDirection: Directionality.of(context),
      ),
      children: <Widget>[
        // Create all of the colored boxes in the colors map.
        for (final MapEntry<String, Color> entry in _colors.entries)
        // The "id" can be any Object, not just a String.
          LayoutId(
            id: entry.key,
            child: Container(
              color: entry.value,
              width: 100.0,
              height: 100.0,
              alignment: Alignment.center,
              child: Text(entry.key),
            ),
          ),
      ],
    );
  }
}
