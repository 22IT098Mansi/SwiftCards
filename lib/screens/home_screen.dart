import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/loyalty_card.dart';
import '../providers/card_provider.dart';
import 'add_card_screen.dart';
import 'card_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load cards when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CardProvider>(context, listen: false).loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Swift Cards',
          style: AppTheme.titleStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
      ),
      body: Consumer<CardProvider>(
        builder: (context, cardProvider, child) {
          if (cardProvider.cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 64,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No cards added yet',
                    style: AppTheme.subtitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first card',
                    style: AppTheme.subtitleStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppTheme.defaultPadding,
              mainAxisSpacing: AppTheme.defaultPadding,
            ),
            itemCount: cardProvider.cards.length,
            itemBuilder: (context, index) {
              final card = cardProvider.cards[index];
              return CardItem(card: card);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCardScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: AppTheme.secondaryColor),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.primaryColor.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final LoyaltyCard card;

  const CardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CardDetailsScreen(card: card),
          ),
        );
      },
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (card.logoPath != null)
                Image.network(
                  card.logoPath!,
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
              const Spacer(),
              Text(
                card.name,
                style: AppTheme.cardTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                card.cardNumber,
                style: AppTheme.cardSubtitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Expires: ${card.expiryDate.day}/${card.expiryDate.month}/${card.expiryDate.year}',
                style: AppTheme.cardExpiryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 