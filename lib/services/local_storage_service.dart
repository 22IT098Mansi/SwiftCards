import 'package:hive_flutter/hive_flutter.dart';
import '../models/loyalty_card.dart';

class LocalStorageService {
  static const String _boxName = 'loyaltyCards';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LoyaltyCardAdapter());
    await Hive.openBox<LoyaltyCard>(_boxName);
  }

  Future<void> saveCard(LoyaltyCard card) async {
    final box = Hive.box<LoyaltyCard>(_boxName);
    await box.put(card.id, card);
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    final box = Hive.box<LoyaltyCard>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteCard(String cardId) async {
    final box = Hive.box<LoyaltyCard>(_boxName);
    await box.delete(cardId);
  }

  Future<void> updateCard(LoyaltyCard card) async {
    final box = Hive.box<LoyaltyCard>(_boxName);
    await box.put(card.id, card);
  }
} 