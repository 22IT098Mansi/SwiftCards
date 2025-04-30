import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/card_model.dart';

class CardDetailsScreen extends StatelessWidget {
  final CardModel card;

  const CardDetailsScreen({super.key, required this.card});

  void _showFullscreenQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: card.barcodeUrl ?? 'CARD${card.id}',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'Show this code to the cashier',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyCardNumber(BuildContext context) {
    // TODO: Implement actual clipboard functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card number copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Card Details',
          style: AppTheme.titleStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Header
            Container(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  if (card.logoUrl != null)
                    Image.network(
                      card.logoUrl!,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.credit_card,
                          size: 60,
                          color: AppTheme.primaryColor.withOpacity(0.5),
                        );
                      },
                    )
                  else
                    Icon(
                      Icons.credit_card,
                      size: 60,
                      color: AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    card.name,
                    style: AppTheme.titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.brandName,
                    style: AppTheme.subtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // QR Code
            Container(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  QrImageView(
                    data: card.barcodeUrl ?? 'CARD${card.id}',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showFullscreenQR(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
                      ),
                    ),
                    icon: const Icon(Icons.fullscreen, color: AppTheme.secondaryColor),
                    label: Text(
                      'Show Fullscreen',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Card Details
            Container(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Details',
                    style: AppTheme.cardTitleStyle,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Card Number',
                    '•••• •••• •••• 1234',
                    onTap: () => _copyCardNumber(context),
                  ),
                  if (card.expiryDate != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Expiry Date',
                      DateFormat('dd/MM/yyyy').format(card.expiryDate!),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.cardSubtitleStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTheme.cardTitleStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.copy,
                color: AppTheme.primaryColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
} 