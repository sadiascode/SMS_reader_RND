import 'package:flutter/material.dart';

import 'package:telephony_sdt/telephony.dart';

class SmsDetailsScreen extends StatelessWidget {
  const SmsDetailsScreen({super.key, required this.sms});

  final SmsMessage sms;

  @override
  Widget build(BuildContext context) {
    final date = sms.date == null
        ? 'Unknown date'
        : DateTime.fromMillisecondsSinceEpoch(sms.date!).toLocal().toString();

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('SMS Details'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sms.address ?? 'Unknown sender',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(date),
            const Divider(height: 32),
            SelectableText(
              sms.body ?? '(No message text)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
