import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/promotion/widgets/promoted_service.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class PromotionCard<T> extends ConsumerWidget {
  final String contentType;
  final T data;
  const PromotionCard(
      {super.key, required this.contentType, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (contentType) {
      'event' => _buildPromotedEvent(context: context, data: data as EventDoc),
      'moment' => const SizedBox(),
      'product' =>
        _buildPromotedProduct(context: context, data: data as Product),
      'page' => _buildPromotedPage(context: context, data: data as PageModel),
      'donation' =>
        _buildPromotedDonation(context: context, data: data as MyDonationDocs),
      'poll & vote' =>
        _buildPromotedDonation(context: context, data: data as MyDonationDocs),
      'post' => _buildPromotedPoll(context: context, data: data as Docs),
      'group' =>
        _buildPromotedGroup(context: context, data: data as GroupModel),
      'contest' => const SizedBox(),

      // fallback widget
      _ => const SizedBox.shrink(),
    };
  }

//> Event
  Widget _buildPromotedEvent(
      {required BuildContext context, required EventDoc data}) {
    return PromotedService(
        title: data.title,
        description: data.description ?? '',
        image: data.image);
  }

//> Product
  Widget _buildPromotedProduct(
      {required BuildContext context, required Product data}) {
    final String image = data.images.isEmpty ? "" : data.images[0];
    return PromotedService(
        title: data.name,
        description: WayaHelpers.formatPrice(double.parse(data.price).toInt()),
        image: image);
  }

  //> Donation
  Widget _buildPromotedDonation(
      {required BuildContext context, required MyDonationDocs data}) {
    return PromotedService(
        title: data.title ?? '',
        description: data.description ?? '',
        image: data.imageURL ?? '');
  }

  //> Page
  Widget _buildPromotedPage(
      {required BuildContext context, required PageModel data}) {
    return PromotedService(
        title: data.name,
        description: data.description,
        image: data.coverImage ?? '');
  }

  //> Group
  Widget _buildPromotedGroup(
      {required BuildContext context, required GroupModel data}) {
    return PromotedService(
        title: data.name,
        description: data.description,
        image: data.coverImage ?? '');
  }

  //> Poll
  Widget _buildPromotedPoll(
      {required BuildContext context, required Docs data}) {
    return PromotedService(
        title: data.description ?? '', description: '', image: '');
  }
}
