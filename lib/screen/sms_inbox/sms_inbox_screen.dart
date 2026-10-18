import 'package:flutter/material.dart';
import 'package:telephony_sdt/telephony.dart';

import '../sms_details/sms_details_screen.dart';

class SmsInboxScreen extends StatefulWidget {
  const SmsInboxScreen({super.key});

  @override
  State<SmsInboxScreen> createState() => _SmsInboxScreenState();
}

class _SmsInboxScreenState extends State<SmsInboxScreen> {
  final Telephony _telephony = Telephony.instance;

  List<SmsMessage> _messages = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSms();
  }

  Future<void> _loadSms() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final granted = await _telephony.requestPhoneAndSmsPermissions;

      if (granted != true) {
        if (mounted) {
          setState(() {
            _error = 'SMS permission was not granted.';
            _loading = false;
          });
        }
        return;
      }

      final messages = await _telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      );

      if (mounted) {
        setState(() {
          _messages = messages;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load messages: $e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('SMS Inbox')),
        actions: [
          IconButton(
            onPressed: _loadSms,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loadSms, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return const Center(child: Text('No SMS messages found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadSms,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _messages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final sms = _messages[index];
          final date = sms.date == null
              ? ''
              : DateTime.fromMillisecondsSinceEpoch(
                  sms.date!,
                ).toLocal().toString();

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.sms_outlined)),
            title: Text(
              sms.address ?? 'Unknown sender',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              sms.body ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              date.isEmpty ? '' : date.substring(0, 16),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SmsDetailsScreen(sms: sms)),
              );
            },
          );
        },
      ),
    );
  }
}
