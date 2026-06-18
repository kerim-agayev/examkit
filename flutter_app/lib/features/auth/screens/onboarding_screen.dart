import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final _controller = PageController();

  static const _pages = [
    _PageData(
      title: 'Sınav Oluştur, Paylaş',
      subtitle: 'Dakikalar içinde sınav hazırla, öğrencilerinle paylaş.',
      icon: Icons.assignment_add,
    ),
    _PageData(
      title: 'WhatsApp ile Tek Tuşta Paylaş',
      subtitle: 'Oluşturduğun sınavı tek dokunuşla WhatsApp grubuna gönder.',
      icon: Icons.share,
    ),
    _PageData(
      title: 'Anlık Sonuçları Gör',
      subtitle: 'Öğrenciler tamamladıkça sonuçları canlı izle.',
      icon: Icons.analytics,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Atla'),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentPage ? theme.colorScheme.primary : const Color(0xFFE2E8F0),
                ),
              )),
            ),
            const SizedBox(height: 24),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Text(_currentPage < _pages.length - 1 ? 'Devam Et' : 'Başla'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_PageData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(page.icon, size: 56, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 32),
          Text(page.title, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(page.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF475569)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PageData {
  final String title;
  final String subtitle;
  final IconData icon;
  const _PageData({required this.title, required this.subtitle, required this.icon});
}
