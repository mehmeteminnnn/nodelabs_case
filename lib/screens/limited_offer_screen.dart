import 'package:flutter/material.dart';

class LimitedOfferScreen extends StatelessWidget {
  const LimitedOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Başlık ve Açıklama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  Text(
                    'Sınırlı Teklif',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jeton paketin\'i seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bonuslar Alanı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _BonusItem(icon: Icons.diamond, label: 'Premium\nHesap'),
                    _BonusItem(
                      icon: Icons.favorite,
                      label: 'Daha\nFazla Eşleşme',
                    ),
                    _BonusItem(icon: Icons.arrow_upward, label: 'Öne\nÇıkarma'),
                    _BonusItem(
                      icon: Icons.favorite_border,
                      label: 'Daha\nFazla Beğeni',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Jeton Paketleri
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Kilidi açmak için bir jeton paketi seçin',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  JetonPaketCard(
                    bonusText: '+10%',
                    eskiFiyat: '200',
                    yeniFiyat: '330',
                    fiyat: '₺99,99',
                  ),
                  JetonPaketCard(
                    bonusText: '+70%',
                    eskiFiyat: '2.000',
                    yeniFiyat: '3.375',
                    fiyat: '₺799,99',
                    gradient: true,
                  ),
                  JetonPaketCard(
                    bonusText: '+35%',
                    eskiFiyat: '1.000',
                    yeniFiyat: '1.350',
                    fiyat: '₺399,99',
                  ),
                ],
              ),
            ),

            // Alt Buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Tüm Jetonları Gör',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BonusItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.pinkAccent),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class JetonPaketCard extends StatelessWidget {
  final String bonusText;
  final String eskiFiyat;
  final String yeniFiyat;
  final String fiyat;
  final bool gradient;

  const JetonPaketCard({
    required this.bonusText,
    required this.eskiFiyat,
    required this.yeniFiyat,
    required this.fiyat,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient:
            gradient
                ? const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color: gradient ? null : Colors.red.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
            child: Column(
              children: [
                Text(
                  eskiFiyat,
                  style: const TextStyle(
                    color: Colors.white54,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  yeniFiyat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jeton',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 8),
                Text(fiyat, style: const TextStyle(color: Colors.white)),
                const Text(
                  'Başına haftalık',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: gradient ? Colors.blueAccent : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                bonusText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
