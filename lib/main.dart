import 'dart:async';
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
          body: Column(
            children: [
              Expanded(flex: 2, child: Container()),
              CustomerCarousel(
                title: 'POC Carousel',
                controller: PageController(viewportFraction: 0.7),

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
              Expanded(flex: 2, child: Container())
            ],
          ),
        ));
  }
}

//  componente
class CustomerCarousel extends StatefulWidget {
  final String title;
  final PageController controller;
  final bool autoPlayInfinity;
  final bool zoomItem;
  final List<Widget> items;

  const CustomerCarousel(
      {super.key,
      required this.title,
      required this.controller,
      this.autoPlayInfinity = true,
      this.zoomItem = false,
      required this.items});

  @override
  State<CustomerCarousel> createState() => _CustomerCarouselState();
}

class _CustomerCarouselState extends State<CustomerCarousel> {
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.autoPlayInfinity) return;
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      widget.controller.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.autoPlayInfinity ? null : widget.items.length,
            controller: widget.controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final int itemIndex =
                  widget.autoPlayInfinity ? index % widget.items.length : index;

              return Transform.scale(
                scale: (widget.zoomItem && index == _currentPage) ? 1 : 0.9,
                child: ItemCarousel(
                  child: widget.items[itemIndex],
                ),
              );
            },
          ),
          if (!widget.autoPlayInfinity) _buildIndexItems(),
        ],
      ),
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
          color: _currentPage == index
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

    return //widget.showIndexListOnStack! ?
        Positioned(
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
