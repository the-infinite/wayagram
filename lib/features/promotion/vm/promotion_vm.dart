import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/promotion/data/models/promotion_plan_response_model.dart';
import 'package:wayagram/features/promotion/data/models/promotion_response_model.dart';
import 'package:wayagram/features/promotion/data/models/promotion_state.dart';
import 'package:wayagram/features/promotion/data/repo/promotion_repository.dart';
import 'package:wayagram/features/shop/vm/product_detail_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';

class PromotionVm extends StateNotifier<PromotionState> {
  final Ref ref;
  final PromotionRepository _repository;

  PromotionVm(this.ref, this._repository) : super(PromotionState());

  Future<List<PromotionPlanDoc>?> getPlans(
      {required String serviceType}) async {
    try {
      final response =
          await _repository.getPromotionPlans(serviceType: serviceType);

      List<PromotionPlanDoc> promoPlans = [];
      if (response.success) {
        debugPrint(response.data.toString());
        PromotionPlanResponse plansResponse =
            PromotionPlanResponse.fromJson(response.data);
        promoPlans = plansResponse.data.docs;
        state = state.copyWith(plans: promoPlans);
      }
      return promoPlans;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<void> getPromos() async {
    try {
      state = state.copyWith(loadingPromos: true);
      final response = await _repository.getPromotions();

      if (response.success) {
        PromotionResponse promotionResponse =
            PromotionResponse.fromJson(response.data);

        if (promotionResponse.data!.docs.isNotEmpty) {
          List<Future<Promotion>> promoFutures =
              promotionResponse.data!.docs.map((promo) async {
            return promo.copyWith(
                metadata: await getServiceData(
                    contentId: promo.contentId,
                    contentType: promo.contentType));
          }).toList();

          List<Promotion> refineAllPromo = await Future.wait(promoFutures);
          state = state.copyWith(allPromotions: refineAllPromo);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(loadingPromos: false);
    }
  }

  Future<void> getSinglePromo({required String id}) async {
    try {
      final response = await _repository.getSinglePromotion(promoId: id);

      if (response.success) {
        debugPrint(response.data.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<dynamic> getServiceData(
      {required String contentId, required String contentType}) async {
    try {
      dynamic metadata;

      switch (contentType) {
        // event
        case 'event':
          metadata = await ref
              .read(eventVmProvider.notifier)
              .getSingleEvent(contentId);
          // EventDoc
          break;

        // moment
        case 'moment':
          metadata = await ref
              .read(momentVmProvider.notifier)
              .getSingleMoment(contentId);

          // MomentData
          break;

        // product
        case 'product':
          metadata = await ref
              .read(productDetailVmProvider.notifier)
              .getCurrentProduct(id: contentId);

          // Product
          break;

        // pages
        case 'page':
          metadata = await myPageNotifier.getSinglePage(contentId);

          // PageModel
          break;

        // groups
        case 'group':
          metadata = await myGroupNotifier.getSingleGroup(contentId);

          // GroupModel
          break;

        // contest
        case 'contest':
          metadata = await ref
              .read(postProvider.notifier)
              .fetchSingleContest(contestId: contentId);

          // Contest
          break;

        // donation
        case 'donation':
          metadata = await ref
              .read(donationVmProvider.notifier)
              .getSingleCampaign(contentId);

          // MyDonationDocs
          break;

        // poll & vote
        case 'poll & vote':
          metadata = await ref
              .read(createPollVotingProvider.notifier)
              .getPollById(contentId);

          //Docs
          break;

        // post
        case 'post':
          metadata = await ref
              .read(createPageProvider.notifier)
              .getSinglePost(contentId);
          //PostModel

          break;

        default:
          null;
      }

      return metadata;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}

final promoteVmProvider =
    StateNotifierProvider<PromotionVm, PromotionState>((ref) {
  return PromotionVm(ref, PromotionRepository());
});
