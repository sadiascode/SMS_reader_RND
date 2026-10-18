import 'package:flutter/material.dart';
import 'package:telephony_sdt/telephony.dart';

final Telephony telephony = Telephony.instance;

// READ_SMS: read inbox
Future<void> readInbox() async {
  final messages = await telephony.getInboxSms();

  for (final sms in messages) {
    debugPrint('${sms.address}: ${sms.body}');
  }
}

// READ_SMS: read sent messages
Future<void> readSent() async {
  final messages = await telephony.getSentSms();

  for (final sms in messages) {
    debugPrint('${sms.address}: ${sms.body}');
  }
}

// READ_SMS: read drafts
Future<void> readDrafts() async {
  final messages = await telephony.getDraftSms();

  for (final sms in messages) {
    debugPrint('${sms.address}: ${sms.body}');
  }
}

// SEND_SMS: send a text directly
Future<void> sendSms(String number, String text) async {
  await telephony.sendSms(to: number, message: text);
}

// SEND_SMS: open the default messaging app with a prepared text
Future<void> composeSms(String number, String text) async {
  await telephony.sendSmsByDefaultApp(to: number, message: text);
}

// RECEIVE_SMS: listen for incoming SMS while the app is open
void listenForSms() {
  telephony.listenIncomingSms(
    onNewMessage: (SmsMessage message) {
      debugPrint('From ${message.address}: ${message.body}');
    },
    listenInBackground: false,
  );
}
