import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:swipe_animation/data/model/cinema_model.dart';

class Repository {
  Future<List<Cinema>> getCinemas() async {
    final response = await rootBundle.loadString('lib/assets/json/cinema.json');

    final data = json.decode(response);
    final List<Cinema> cinemas = [];
    for (final item in data['cinemas']) {
      cinemas.add(Cinema.fromJson(item));
    }

    return cinemas;
  }

  Future<Cinema> getCinemaById(String id) async {
    final response = await getCinemas();

    final cinema = response.firstWhere((element) => element.id == id);
    return cinema;
  }
}
