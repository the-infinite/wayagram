import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/promotion/widgets/promoted_service.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class PromotionCard extends ConsumerWidget {
  final String contentType;
  final dynamic data;
  final bool showTimeLeft;
  final String? timeLeft;
  final String? id;
  const PromotionCard(
      {super.key,
      required this.contentType,
      required this.data,
      this.timeLeft = '',
      this.id,
      this.showTimeLeft = false});

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
      'poll & vote' => _buildPromotedPoll(context: context, data: data as Docs),
      'post' => _buildPromotedPost(context: context, data: data as PostModel),
      'group' =>
        _buildPromotedGroup(context: context, data: data as GroupModel),
      'contest' => const SizedBox(),

      // fallback widget
      _ => const SizedBox.shrink(),
    };
  }
  //

//> Event
  Widget _buildPromotedEvent(
      {required BuildContext context, required EventDoc data}) {
    return PromotedService(
        title: data.title,
        description: data.description ?? '',
        showTimeLeft: showTimeLeft,
        timeLeft: timeLeft,
        id: id,
        image: data.image);
  }

//> Product
  Widget _buildPromotedProduct(
      {required BuildContext context, required Product data}) {
    final String image = data.images.isEmpty ? "" : data.images[0];
    return PromotedService(
        title: data.name,
        showTimeLeft: showTimeLeft,
        timeLeft: timeLeft,
        id: id,
        description: WayaHelpers.formatPrice(double.parse(data.price).toInt()),
        image: image);
  }

  //> Donation
  Widget _buildPromotedDonation(
      {required BuildContext context, required MyDonationDocs data}) {
    return PromotedService(
        title: data.title ?? '',
        description: data.description ?? '',
        showTimeLeft: showTimeLeft,
        timeLeft: timeLeft,
        id: id,
        image: data.imageURL ?? '');
  }

  //> Page
  Widget _buildPromotedPage(
      {required BuildContext context, required PageModel data}) {
    return PromotedService(
        title: data.name,
        description: data.description,
        timeLeft: timeLeft,
        id: id,
        showTimeLeft: showTimeLeft,
        image: data.coverImage ?? '');
  }

  //> Group
  Widget _buildPromotedGroup(
      {required BuildContext context, required GroupModel data}) {
    return PromotedService(
        title: data.name,
        description: data.description,
        showTimeLeft: showTimeLeft,
        id: id,
        timeLeft: timeLeft,
        image: data.coverImage ?? '');
  }

  //> Poll
  Widget _buildPromotedPoll(
      {required BuildContext context, required Docs data}) {
    return PromotedService(
        title: data.description ?? '',
        showTimeLeft: showTimeLeft,
        timeLeft: timeLeft,
        id: id,
        description: '',
        image:
            'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1744627768/Misc_icon_y32o57.png');
  }

//> Post
  Widget _buildPromotedPost(
      {required BuildContext context, required PostModel data}) {
    final String media = data.media.isEmpty ? "" : data.media[0];
    return PromotedService(
        showTimeLeft: showTimeLeft,
        timeLeft: timeLeft,
        id: id,
        title:
            "${data.user?.firstName.capitalizeFirst} ${data.user?.lastName.capitalizeFirst}",
        description: data.content,
        image: media);
  }
}
