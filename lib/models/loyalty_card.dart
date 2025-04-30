import 'package:hive/hive.dart';

part 'loyalty_card.g.dart';

@HiveType(typeId: 0)
class LoyaltyCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String cardNumber;

  @HiveField(3)
  final DateTime expiryDate;

  @HiveField(4)
  final String barcodeValue;

  @HiveField(5)
  final String? logoPath;

  @HiveField(6)
  final bool isSynced;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
    required this.barcodeValue,
    this.logoPath,
    this.isSynced = false,
  });
} 