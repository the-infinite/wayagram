import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

final shareProvider = Provider((ref) => ShareService());

class ShareService {
  Future<void> copyLink(String shareUrl) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
  }

  Future<void> shareViaWhatsapp(String shareUrl) async {
    final url = Uri.parse('whatsapp://send?text=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaEmail(String shareUrl) async {
    final url = Uri.parse('mailto:?subject=Check this out&body=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaTelegram(String shareUrl) async {
    final url = Uri.parse('https://t.me/share/url?url=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaFacebook(String shareUrl) async {
    final url =
        Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaLinkedIn(String shareUrl) async {
    final url = Uri.parse(
        'https://www.linkedin.com/sharing/share-offsite/?url=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaX(String shareUrl) async {
    final url = Uri.parse('https://twitter.com/intent/tweet?url=$shareUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareViaInstagram(String shareUrl) async {
    // Instagram doesn't support direct sharing via URL scheme
    // We'll use the general share dialog instead
    await SharePlus.instance.share(ShareParams(
      text: shareUrl,
      subject: 'Check this out',
    ));
  }

  Future<void> shareViaContacts(String shareUrl) async {
    await SharePlus.instance.share(ShareParams(
      text: shareUrl,
      subject: 'Check this out',
    ));
  }

  Future<void> shareViaSystem(String shareUrl) async {
    await SharePlus.instance.share(ShareParams(
      text: shareUrl,
      subject: 'Check this out',
    ));
  }
}
