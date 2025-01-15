import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/dispute_chat/widgets/dispute_buyer_info.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/dispute_chat/widgets/dispute_chat_input.dart';
import 'package:gap/gap.dart';
class DisputeChat extends ConsumerStatefulWidget {
  static const route = '/dispute-chat';
  const DisputeChat({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisputeChatState();
}

class _DisputeChatState extends ConsumerState<DisputeChat> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'Dispute Chat',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DisputeBuyerInfo(),
            Expanded(
              
              child: ListView(
                shrinkWrap: true,
               
                children: [
                  SellerChat(),
                  BuyerChat()
                ],
              ),
            ),
            DisputeChatInput()
          ],
        ));
  }
}

class SellerChat extends StatelessWidget {
  const SellerChat({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Admin message
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(bottom:8),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.customPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Hello! I am messaging as regards your dispute, your evidence is not enough, send more details.',
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ),

        // Time stamp
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '4:59 PM',
            style: TextStyle(
                color: wayaTheme.colorScheme.greyColor300, fontSize: 12),
          ),
        ),
        const Gap(15)
      ],
    );
  }
}

class BuyerChat extends StatelessWidget {
  const BuyerChat({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User message
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'The product was broken, i will send more image now.',
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ),
          const Gap(15)
      ],
    );
  }
}
