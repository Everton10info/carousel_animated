import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 200,
                child: CustomerCarousel(
                  showIndexListOnStack: true,
                  controller: PageController(viewportFraction: 0.7),
                  zoomItem: false,
                  autoPlay: false,
                  infinity: true,
                  items: [
                    Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
                    ),
                    Image.network("https://wallpaperaccess.com/full/2637581.jpg"),
                    Image.network(
                        "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg"),
                    Image.network(
                        "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg")
                  ],
                ),
              ),

            ],
          ),
        ));
  }
}

//  componente
class CustomerCarousel extends StatefulWidget {
  final PageController controller;
  final List<Widget> items;
  final bool autoPlay;
  final bool showIndexListOnStack;
  final bool infinity;
  final bool zoomItem;

  const CustomerCarousel({
    super.key,
    required this.controller,
    required this.items,
    required this.autoPlay,
    required this.showIndexListOnStack,
    this.infinity = false,
    this.zoomItem = false,
  });

  @override
  State<CustomerCarousel> createState() => _CustomerCarouselState();
}

class _CustomerCarouselState extends State<CustomerCarousel> {
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.autoPlay) return;
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      widget.controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      if (widget.infinity == false && _currentPage == widget.items.length - 2) {
        _timer.cancel();
      }
      ;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.infinity ? null : widget.items.length,
          controller: widget.controller,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index % widget.items.length;
            });
          },
          itemBuilder: (context, index) {
            final int itemIndex =
                widget.infinity ? index % widget.items.length : index;

            return Transform.scale(
              scale: (widget.zoomItem &&
                      index % widget.items.length == _currentPage)
                  ? 1
                  : 0.8,
              child: ItemCarousel(
                child: widget.items[itemIndex],
              ),
            );
          },
        ),
        SizedBox(height: 20,),
        if (widget.showIndexListOnStack) _buildIndexItems(),
      ],
    );
  }

  List<Widget> mapWidgets() {
    final List<Widget?> widgets = map<Widget>(widget.items, (index) {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index % widget.items.length
              ? const Color(0XFFDD4084)
              : const Color(0XFFDD4084).withOpacity(0.5),
        ),
      );
    }).toList();

    final List<Widget> ws = widgets.map((e) => e!).toList();

    return ws;
  }

  List<T?> map<T>(
    List<Widget> list,
    Widget Function(int index) handler,
  ) {
    final List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i) as T?);
    }
    return result;
  }

  Widget _buildIndexItems() {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mapWidgets(),
    );

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: row,
    );
    //: Container(child: row);
  }
}

class ItemCarousel extends StatelessWidget {
  final Widget? child;

  const ItemCarousel({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 15 * 1.5, right: 15 * 1.5),
      child: child,
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Carousel',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late final PageController _controller;
//   late final Timer _timer;
//   int _currentPage = 0;
//   final List<String> _imageUrls = [
//     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
//     "https://wallpaperaccess.com/full/2637581.jpg",
//     "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
//     "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = PageController(
//       initialPage: _currentPage,
//       viewportFraction: 0.7,
//     );
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Carousel'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _controller,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//              // itemCount: _imageUrls.length,
//               itemBuilder: (context, index) {
//                 final int itemIndex = index % _imageUrls.length;
//                 return Transform.scale(
//                   scale: index == _currentPage ? 1 : 0.8,
//                   child: Image.network(_imageUrls[itemIndex]),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: _buildIndexIndicators(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildIndexIndicators() {
//     return List<Widget>.generate(
//       _imageUrls.length,
//           (index) => Container(
//         width: 8.0,
//         height: 8.0,
//         margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: _currentPage == index
//               ? Colors.deepPurple
//               : Colors.deepPurple.withOpacity(0.5),
//         ),
//       ),
//     );
//   }
// }
