import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardProvider extends ChangeNotifier {
  final List<CardModel> _cards = [
    CardModel(
      id: '1',
      name: 'Starbucks Rewards',
      brandName: 'Starbucks',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/1200px-Starbucks_Corporation_Logo_2011.svg.png',
      expiryDate: DateTime(2025, 12, 31),
    ),
    CardModel(
      id: '2',
      name: 'Amazon Prime',
      brandName: 'Amazon',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/1200px-Amazon_logo.svg.png',
      expiryDate: DateTime(2024, 6, 30),
    ),
    CardModel(
      id: '3',
      name: 'Netflix Premium',
      brandName: 'Netflix',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/1200px-Netflix_2015_logo.svg.png',
      expiryDate: DateTime(2024, 3, 15),
    ),
  ];

  List<CardModel> get cards => _cards;

  void addCard(CardModel card) {
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(String id) {
    _cards.removeWhere((card) => card.id == id);
    notifyListeners();
  }
} 