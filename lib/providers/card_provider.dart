import 'package:flutter/foundation.dart';
import '../models/loyalty_card.dart';
import '../services/local_storage_service.dart';
import '../services/sync_service.dart';

class CardProvider with ChangeNotifier {
  final LocalStorageService _localStorage;
  final SyncService _syncService;
  List<LoyaltyCard> _cards = [];

  CardProvider({
    required LocalStorageService localStorageService,
    required SyncService syncService,
  })  : _localStorage = localStorageService,
        _syncService = syncService {
    loadCards();
  }

  List<LoyaltyCard> get cards => _cards;

  Future<void> loadCards() async {
    _cards = await _localStorage.getAllCards();
    notifyListeners();
  }

  Future<void> addCard(LoyaltyCard card) async {
    await _localStorage.saveCard(card);
    await loadCards();
    await _syncService.syncWithCloud();
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await _localStorage.updateCard(card);
    await loadCards();
    await _syncService.syncWithCloud();
  }

  Future<void> deleteCard(String cardId) async {
    await _localStorage.deleteCard(cardId);
    await loadCards();
    await _syncService.syncWithCloud();
  }
} 