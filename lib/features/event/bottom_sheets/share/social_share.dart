import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/event/bottom_sheets/share/share_provider.dart';

class ShareOption {
  final String title;
  final Widget icon;
  final Function() onTap;

  ShareOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ShareSheet extends ConsumerWidget {
  final String shareUrl;
  const ShareSheet({super.key, required this.shareUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareService = ref.watch(shareProvider);
    final wayaTheme = Theme.of(context);

    final List<ShareOption> topOptions = [
      ShareOption(
        title: 'Copy Link',
        icon: SvgPicture.asset(WayaAssets.icons.sLink.path),
        onTap: () => shareService.copyLink(shareUrl),
      ),
      ShareOption(
        title: 'Contacts',
        icon: SvgPicture.asset(WayaAssets.icons.sContact.path),
        onTap: () => shareService.shareViaContacts(shareUrl),
      ),
      ShareOption(
        title: 'WhatsApp',
        icon: SvgPicture.asset(WayaAssets.icons.sWhatsapp.path),
        onTap: () => shareService.shareViaWhatsapp(shareUrl),
      ),
      ShareOption(
        title: 'Email',
        icon: SvgPicture.asset(WayaAssets.icons.sEmail.path),
        onTap: () => shareService.shareViaEmail(shareUrl),
      ),
      ShareOption(
        title: 'Share Via',
        icon: SvgPicture.asset(WayaAssets.icons.sShare.path),
        onTap: () => shareService.shareViaSystem(shareUrl),
      ),
    ];

    final List<ShareOption> bottomOptions = [
      ShareOption(
        title: 'Facebook',
        icon: SvgPicture.asset(WayaAssets.icons.sFb.path),
        onTap: () => shareService.shareViaFacebook(shareUrl),
      ),
      ShareOption(
        title: 'Instagram',
        icon: SvgPicture.asset(WayaAssets.icons.sInsta.path),
        onTap: () => shareService.shareViaInstagram(shareUrl),
      ),
      ShareOption(
        title: 'LinkedIn',
        icon: SvgPicture.asset(WayaAssets.icons.sLinkedin.path),
        onTap: () => shareService.shareViaLinkedIn(shareUrl),
      ),
      ShareOption(
        title: 'Telegram',
        icon: SvgPicture.asset(WayaAssets.icons.sTelegram.path),
        onTap: () => shareService.shareViaTelegram(shareUrl),
      ),
      ShareOption(
        title: 'X',
        icon: SvgPicture.asset(WayaAssets.icons.sX.path),
        onTap: () => shareService.shareViaX(shareUrl),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share options',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                topOptions.map((option) => _buildShareOption(option)).toList(),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomOptions
                .map((option) => _buildShareOption(option))
                .toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShareOption(ShareOption option) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(onTap: option.onTap, child: option.icon),
        const SizedBox(height: 8),
        Text(
          option.title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
