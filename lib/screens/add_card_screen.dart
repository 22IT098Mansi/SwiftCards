import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/loyalty_card.dart';
import '../providers/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  DateTime? _expiryDate;
  String? _logoPath;
  String? _barcodeValue;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _scanBarcode() async {
    setState(() => _isLoading = true);
    try {
      // Dummy scan action
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _barcodeValue = 'CARD${DateTime.now().millisecondsSinceEpoch}';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barcode scanned successfully')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickLogo() async {
    setState(() => _isLoading = true);
    try {
      // Dummy image picker action
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _logoPath = 'https://example.com/logo.png';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logo selected')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final card = LoyaltyCard(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          cardNumber: _numberController.text,
          expiryDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
          barcodeValue: _barcodeValue ?? _numberController.text,
          logoPath: _logoPath,
        );

        await context.read<CardProvider>().addCard(card);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card added successfully')),
          );
          Navigator.pop(context);
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Card',
          style: AppTheme.titleStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card Preview
                  Container(
                    padding: const EdgeInsets.all(AppTheme.defaultPadding),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      children: [
                        if (_logoPath != null)
                          Image.network(
                            _logoPath!,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.credit_card,
                                size: 40,
                                color: AppTheme.primaryColor.withOpacity(0.5),
                              );
                            },
                          )
                        else
                          Icon(
                            Icons.credit_card,
                            size: 40,
                            color: AppTheme.primaryColor.withOpacity(0.5),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          _nameController.text.isEmpty ? 'Card Name' : _nameController.text,
                          style: AppTheme.cardTitleStyle,
                          textAlign: TextAlign.center,
                        ),
                        if (_numberController.text.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _numberController.text,
                            style: AppTheme.cardSubtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (_expiryDate != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Expires: ${DateFormat('dd/MM/yyyy').format(_expiryDate!)}',
                            style: AppTheme.cardExpiryStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Form Fields
                  TextFormField(
                    controller: _nameController,
                    decoration: AppTheme.inputDecoration.copyWith(
                      labelText: 'Card Name',
                      prefixIcon: const Icon(Icons.credit_card),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card name';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberController,
                    decoration: AppTheme.inputDecoration.copyWith(
                      labelText: 'Card Number',
                      prefixIcon: const Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      if (value.length < 8) {
                        return 'Card number must be at least 8 characters';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.defaultPadding,
                        vertical: AppTheme.defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppTheme.primaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _expiryDate != null
                                ? DateFormat('dd/MM/yyyy').format(_expiryDate!)
                                : 'Select Expiry Date',
                            style: TextStyle(
                              color: _expiryDate != null
                                  ? AppTheme.primaryColor
                                  : AppTheme.primaryColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _pickLogo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.image, color: AppTheme.secondaryColor),
                          label: Text(
                            'Pick Logo',
                            style: AppTheme.buttonTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _scanBarcode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.qr_code_scanner, color: AppTheme.secondaryColor),
                          label: Text(
                            'Scan Barcode',
                            style: AppTheme.buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Add Card',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
} 