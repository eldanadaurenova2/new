// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../data/hotels.dart';
import '../models/hotel.dart';
import 'hotel_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> cities = const ['Astana', 'Almaty', 'Shymkent'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: cities.map((city) {
        final List<Hotel> cityHotels = allHotels
            .where((hotel) => hotel.city.toLowerCase() == city.toLowerCase())
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 9),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cityHotels.length,
                itemBuilder: (context, index) {
                  final hotel = cityHotels[index];
                  return HotelCardWithFavorite(hotel: hotel);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}

// Новый виджет с анимированным сердцем
class HotelCardWithFavorite extends StatefulWidget {
  final Hotel hotel;
  const HotelCardWithFavorite({super.key, required this.hotel});

  @override
  State<HotelCardWithFavorite> createState() => _HotelCardWithFavoriteState();
}

class _HotelCardWithFavoriteState extends State<HotelCardWithFavorite>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.2,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(hotel: widget.hotel),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    widget.hotel.imagePath,
                    height: 270,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: GestureDetector(
                        onTap: () {
                          _toggleFavorite();
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.hotel.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
