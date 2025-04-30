class CardModel {
  final String id;
  final String name;
  final String brandName;
  final String? logoUrl;
  final String? barcodeUrl;
  final DateTime? expiryDate;

  CardModel({
    required this.id,
    required this.name,
    required this.brandName,
    this.logoUrl,
    this.barcodeUrl,
    this.expiryDate,
  });
} 