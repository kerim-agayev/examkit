import 'package:flutter/material.dart';

/// Full-screen loading overlay.
class LoadingOverlay extends StatelessWidget {
  final String? message;
  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const CircularProgressIndicator(color: Color(0xFF2563EB)),
              if (message != null) ...[const SizedBox(height: 16), Text(message!, style: const TextStyle(fontSize: 14, color: Color(0xFF475569)))],
            ]),
          ),
        ),
      ),
    );
  }
}
