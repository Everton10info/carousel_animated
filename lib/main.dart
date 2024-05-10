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
              const CustomerCarousel(title: 'POC Carousel'),
              Expanded(flex: 2, child: Container())
            ],
          ),
        ));
  }
}

//  componente
class CustomerCarousel extends StatefulWidget {
  const CustomerCarousel({super.key, required this.title});

  final String title;

  @override
  State<CustomerCarousel> createState() => _CustomerCarouselState();
}

class _CustomerCarouselState extends State<CustomerCarousel> {
  List<Widget> images = [
    Image.network(
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
    ),
    Image.network("https://wallpaperaccess.com/full/2637581.jpg"),
    Image.network(
        "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg"),
    Image.network(
        "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg")
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Stack(
      children: [
        CarouselSlider(
          onChange: (index) {
            setState(() {
              current = index;
            });
          },
          zoomItem: true,
          items: images,
          controller: PageController(viewportFraction: 0.7),
          infinity: true,
        ),
        // if (widget.showIndexListOnStack! && widget.enableIndexList!)
        _buildIndexItems(),
      ],
    ));
  }

  List<Widget> mapWidgets() {
    final List<Widget?> widgets = map<Widget>(images, (index) {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: current == index
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

class CarouselSlider extends StatefulWidget {
  final List items;
  final PageController controller;
  final bool autoPlay;
  final bool infinity;
  final bool zoomItem;
  final dynamic Function(int) onChange;

  const CarouselSlider({
    super.key,
    required this.items,
    required this.controller,
    required this.onChange,
    this.infinity = false,
    this.autoPlay = false,
    this.zoomItem = false,
  });

  @override
  CarouselSliderState createState() => CarouselSliderState();
}

class CarouselSliderState extends State<CarouselSlider> {
  final int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.autoPlay) return;
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
    return PageView.builder(
      itemCount: widget.infinity ? null : widget.items.length,
      controller: widget.controller,
      onPageChanged: widget.onChange,
      itemBuilder: (context, index) {
        final int itemIndex = index % widget.items.length;
        return Transform.scale(
          scale: (widget.zoomItem && index == _currentPage) ? 1 : 0.9,
          child: ItemCarousel(
            child: widget.items[itemIndex],
          ),
        );
      },
    );
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
