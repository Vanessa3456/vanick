
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


AIService aiService=AIService();



Future<LatLng> getPosition(String userText,BuildContext con) async {

  String prompt = "Give me the accurate position (including latitude and longitude) of the place named \"$userText\". "
      "Return the result in JSON format like: "
      "{ \"latitude\": 1.2921333342, \"longitude\": 36.8219456677 }";

  String response = await aiService.getAIResponse(prompt);
  // ScaffoldMessenger.of(con).showSnackBar(
  //   SnackBar(content: Text('Response $response')),
  // );

  Map<String, dynamic> data = jsonDecode(response.replaceAll(RegExp(r'```json|```'), '').trim());
  // ScaffoldMessenger.of(con).showSnackBar(
  //   SnackBar(content: Text('LatLong $data')),
  // );
  return LatLng(data['latitude'],  data['longitude']);

    Position(
    latitude: data['latitude'],
    longitude: data['longitude'],
    timestamp: DateTime.now(),
    accuracy: 1.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );
}




class AIService {
  final String apiKey = "AIzaSyBGFC9cnNJEC822NAKicHbX4PJsE1PGn4c";
  final GenerativeModel model;

  AIService()
      : model = GenerativeModel(
    model: "gemini-2.0-flash",
    apiKey: "AIzaSyBGFC9cnNJEC822NAKicHbX4PJsE1PGn4c",
  );

  Future<String> getAIResponse(String userMessage) async {
    final response = await model.generateContent([Content.text(userMessage)]);
    return response.text ?? "Sorry, I couldn't understand.";
  }
}