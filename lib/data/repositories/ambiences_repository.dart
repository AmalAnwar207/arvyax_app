import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbiencesRepository {
  Future<List<Ambience>> getAmbiences() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/ambiences.json');

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((e) => Ambience.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load ambiences: $e');
    }
  }
}