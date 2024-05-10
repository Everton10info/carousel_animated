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
      home: const MyHomePage(title: 'POC Carousel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: CarouselCustomer(
          zoomItem: true,
          items: images,
          controller: PageController(viewportFraction: 0.7),
          infinity: true,
        ),
      ),
    );
  }
}

class CarouselCustomer extends StatefulWidget {
  final List items;
  final PageController controller;
  final bool autoPlay;
  final bool infinity;
  final bool zoomItem;

  const CarouselCustomer({
    super.key,
    required this.items,
    required this.controller,
    required this.infinity,
    this.autoPlay = false,
    this.zoomItem = false,
  });

  @override
  CarouselCustomerState createState() => CarouselCustomerState();
}

class CarouselCustomerState extends State<CarouselCustomer> {
  int _currentPage = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel Example'),
      ),
      body: PageView.builder(
        itemCount: widget.infinity ? null : widget.items.length,
        controller: widget.controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          final int itemIndex = index % widget.items.length;
          return Transform.scale(
            scale: (widget.zoomItem && index == _currentPage) ? 1 : 0.9,
            child: ItemCarousel(
              child: widget.items[itemIndex],
            ),
          );
        },
      ),
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
