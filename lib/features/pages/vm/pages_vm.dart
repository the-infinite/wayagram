// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/pages/data/model/page_popular_post_model.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/data/model/pages_users_follow_model.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';
import 'package:wayagram/features/post/model/saved_posts.dart';

import '../../group/data/model/group_post_model.dart';

class UploadedImage {
  final String url;
  final String file;
  final String fileName;

  UploadedImage({required this.url, required this.file, required this.fileName});
}

class PageVm extends StateNotifier<PageState> {
  final Ref ref;
  final PageRepository _pageRepository;

  final _logger = getLogger('PageVm');

  PageVm(
    this.ref,
    this._pageRepository,
  ) : super(PageState()) {
    state = state.copyWith(pageName: TextEditingController(text: ''));
    state = state.copyWith(pageDescription: TextEditingController(text: ''));
    state = state.copyWith(content: TextEditingController(text: ''));
  }

  void reset() {
    state.pageName.clear();
    state.pageDescription.clear();
    state.content.clear();
  }

  final String _errorMessage = '';
  final int _totalPages = 0;

  String get errorMessage => _errorMessage;
  int get totalPages => _totalPages;

  final List<SavedPost> _savedPosts = [];
  String _errorMessage2 = '';
  List<SavedPost> get savedPosts => _savedPosts;
  String get errorMessage2 => _errorMessage2;

  void updateValue(RxInt value, bool isIncreased) {
    if (isIncreased) {
      value.value++;
    } else {
      value.value--;
    }
  }

  void clearText() {
    state.content.clear();
  }

  String getText() {
    return state.content.text;
  }

  void setText(String text) {
    state.content.text = text;
  }

  Future<void> unsavePost(BuildContext context, String postId) async {
    try {
      final response = await _pageRepository.delete(postId);

      if (response.statusCode == 200) {
        await getSinglePost(postId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post unsaved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unsave post. Try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error unsaving post. Try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  //save post
  Future<void> savePost(BuildContext context, postId) async {
    try {
      final response = await _pageRepository.savePost(postId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getSinglePost(postId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post saved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save post. Try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving post. Try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> fetchSavedPosts(userId) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchPost(userId);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        FetchAllPost responseModel = FetchAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(fetchAllPostData: responseModel.data?.docs);

        // Clear existing saved posts
        _savedPosts.clear();
      } else {
        _errorMessage2 = 'Failed to fetch saved posts. Status code: ${response.statusCode}';
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
      _errorMessage2 = 'Something went wrong. Please try again later.';
    } finally {
      // _isLoading = false;
      // notifyListeners();
      //debugPrint('Saved posts fetch completed. Loading state: $_isLoading');
    }
  }

  Future<void> getAllPosts(id) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchPost(id);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        GroupPostModel postModel = GroupPostModel.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(getAllPost: responseModel.data?.docs, postCount: postModel.data?.totalPages);
      } else {
        _errorMessage2 = 'Failed to fetch saved posts. Status code: ${response.statusCode}';
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
      _errorMessage2 = 'Something went wrong. Please try again later.';
    } finally {}
  }

  Future<PostModel?> getSinglePost(String postId) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchSinglePost(postId);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(getAllPost: responseModel.data?.docs);
        return responseModel.data?.docs?.first;
      } else {
        _errorMessage2 = 'Failed to fetch saved posts. Status code: ${response.statusCode}';
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
      _errorMessage2 = 'Something went wrong. Please try again later.';
    } finally {}

    //? Return null.
    return null;
  }

  Future<void> reportPage({
    required String pageId,
    required String reason,
    String? comment,
    required BuildContext context,
  }) async {
    try {
      state = state.copyWith(isReportingPage: true);
      final response = await _pageRepository.reportPage(pageId, reason);

      if (response.success && context.mounted) {
        // show success modal
        wayaPageCache.deleteItem(pageId);
        // WayaNav.goBack();

        if (context.mounted) {
          await WayaUtils.showNotice(
            context: context,
            title: "Thank you for reporting",
            onPress: () {
              WayaNav.goBack();
            },
            icon: Image.asset(
              WayaAssets.images.eCheckEvent.path,
              scale: 1.5,
            ),
            message: 'Your report has been submitted. Our team will review the issue and take appropriate action.',
            buttonText: 'Go to Page Dashboard',
          );

          //? This is fine.
          WayaNav.goBack();
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingPage: false);
    }
  }

  Future<void> reportPost({
    required String postId,
    required String reason,
    String? comment,
  }) async {
    try {
      state = state.copyWith(isReportingPost: true);
      final response = await _pageRepository.reportPost(postId, reason);

      if (response.success) {
        wayaPostCache.deleteItem(postId);
        // This is fine.
        WayaNav.goBack();

        await WayaUtils.showNotice(
          context: WayaNav.context,
          title: "Thank you for reporting",
          onPress: () => WayaNav.goBack(),
          icon: Image.asset(
            WayaAssets.images.eCheckEvent.path,
            scale: 1.5,
          ),
          message: 'Your report has been submitted. Our team will review the issue and take appropriate action.',
          buttonText: 'Go to Page Dashboard',
        );

        // This is fine.
        // WayaNav.goBack();
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingPost: false);
    }
  }

  Future<void> reportGroupPost({
    required String postId,
    required String reason,
    String? comment,
    required BuildContext context,
  }) async {
    try {
      state = state.copyWith(isReportingPost: true);
      final response = await _pageRepository.reportPost(postId, reason);

      if (response.success) {
        wayaPostCache.deleteItem(postId);
        WayaUtils.showNotice(
          context: WayaNav.context,
          title: "Thank you for reporting",
          onPress: () => WayaNav.goBack(),
          icon: Image.asset(
            WayaAssets.images.eCheckEvent.path,
            scale: 1.5,
          ),
          message: 'Your report has been submitted. Our team will review the issue and take appropriate action.',
          buttonText: 'Go to Page Dashboard',
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingPost: false);
    }
  }

  Future<void> createPost(ctx, content, postType, List<XFile> images) async {
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    // get url
    for (XFile image in images) {
      final uploadImageResponse = await _pageRepository.getUploadImage(image.name);
      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
      publicUrl.add(mediaUploadModel.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _pageRepository.putImage(url.url, file);

      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }
    }
    //WayaHelpers.

    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.createPost(content, publicUrl, postType);
      //final response = await _pageRepository.createPost(content, choiceMap, postType);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        final post = PostModel.fromJson(response.data['data']);
        wayaPostCache.cache(post.id, post);

        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async => await deletePost(
                ctx,
                postId: post.id,
                userId: ConversationState.self.id,
                notify: false,
              ),
            ),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<PostModel?> repostPost(BuildContext context, PostModel post) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.createPost(
        post.content,
        post.media,
        post.privacy,
        post.id,
      );
      state = state.copyWith(isLoading: false);

      if (response.success) {
        final post = PostModel.fromJson(response.data['data']);
        wayaPostCache.cache(post.id, post);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This post has been reposted successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async => await deletePost(
                context,
                postId: post.id,
                userId: ConversationState.self.id,
                notify: false,
              ),
            ),
          ),
        );

        return post;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> createPagePost(ctx, String content, String postType, List<XFile> images, String pageId) async {
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    // get url
    for (XFile image in images) {
      final uploadImageResponse = await _pageRepository.getUploadImage(image.name);
      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
      publicUrl.add(mediaUploadModel.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _pageRepository.putImage(url.url, file);

      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }
    }

    try {
      state = state.copyWith(isLoading: true, allPostData: null);
      final response = await _pageRepository.createPagePost(content, publicUrl, postType, pageId);
      state = state.copyWith(isLoading: false);

      //? If this is fine...
      if (response.success) {
        final page = await myPageNotifier.getSinglePage(pageId);
        final post = PostModel.fromJson(response.data['data']).copyWith(page: page);
        final previous = state.getAllPost;
        wayaPostCache.cache(post.id, post);

        //? Then update the list of posts with the one that has just been made.
        state = state.copyWith(
          getAllPost: [post, ...(previous ?? [])],
        );

        //? This is fine.
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async => await deletePost(
                ctx,
                postId: post.id,
                userId: ConversationState.self.id,
                notify: false,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getPagePosts(String pageId) async {
    //? When there is nothing more to give,
    if (!state.hasMorePosts || state.isLoading) {
      return;
    }

    //? Try to load more data.
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchSinglePagePost(pageId, state.allPostData?.data?.nextPage ?? 1);

      if (response.success) {
        final result = <PostModel>[];

        //? First, these ones.
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);

        //? If the current post data is not the current page.
        if ((state.allPostData?.data?.page ?? 1) > 1) {
          result.addAll(state.getAllPost ?? []);
        }

        //? Now, add all the newer posts.
        result.addAll(responseModel.data?.docs ?? []);

        //? Now, move forward.
        state = state.copyWith(
          getAllPost: result,
          postCount: responseModel.data?.totalDocs,
          allPostData: responseModel,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> deletePost(ctx, {required String postId, required String userId, bool notify = true}) async {
    try {
      final response = await _pageRepository.deletePost(postId);
      if (response.success) {
        wayaPostCache.deleteItem(postId);
        if (notify) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Post deleted successfully!'),
              backgroundColor: WayaColors.primary,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deletePage(
    ctx, {
    required String pageId,
  }) async {
    try {
      final response = await _pageRepository.deletePage(pageId);
      if (response.success) {
        wayaPostCache.deleteItem(pageId);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Page deleted successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> repost(ctx, {required String postId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.repost(postId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        await getSinglePost(postId);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Post reposted successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> sharePost(ctx, {required String postId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.sharePost(postId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        await getSinglePost(postId);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> bookmarkPost(ctx, {required String postId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.bookMarkPost(postId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        await getSinglePost(postId);
        WayaSnackBar.showToast('Post bookmarked successfully!');
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> likePost(ctx, {required String postId, required String userId}) async {
    try {
      //state = state.copyWith(isLoading: true);
      final response = await _pageRepository.likePost(postId);

      if (response.success && ctx.mounted) {
        await getSinglePost(postId);
      }

      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      //state = state.copyWith(isLoading: false);
    }

    return false;
  }

  Future<bool> unlikePost(ctx, {required String postId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.unlikePost(postId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        await getSinglePost(postId);
        return response.success;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return false;
  }

  Future<void> editPost(ctx, content, postType, List<XFile> images, postId) async {
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    // get url
    for (XFile image in images) {
      final uploadImageResponse = await _pageRepository.getUploadImage(image.name);
      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
      publicUrl.add(mediaUploadModel.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _pageRepository.putImage(url.url, file);
      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }
    }

    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.editPost(content, publicUrl, postType, postId);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        await getSinglePost(postId);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Post updated successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getPopularPosts() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchPopularPost();
      state = state.copyWith(isLoading: false);

      if (response.success) {
        final responseModel = PagePopularPostModel.fromJson(response.data);

        //? Now, add these ones.
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(pagePopularPostDocs: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getPageMember(pageId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.getPageMembers(pageId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetPageMemberModel responseModel = GetPageMemberModel.fromJson(response.data);
        state = state.copyWith(getPageMemberDocs: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getRecommendedPages() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.getRecommendedPages();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PagesUsersFollowModel responseModel = PagesUsersFollowModel.fromJson(response.data);
        wayaPageCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(recommendedPages: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<bool> updateTeamMember(BuildContext ctx, String role, String pageId, String memberId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.updateTeamMember(role, pageId, memberId);
      state = state.copyWith(isLoading: false);
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return false;
  }

  void setAddedUser(String? id) {
    if (state.foundUserId == id) return;
    state = state.copyWith(
      foundUserId: id,
    );
  }

  void selectRoleType(String value) {
    state = state.copyWith(roleType: value.toLowerCase());
  }

  void prefillFunc(PageModel page) {
    state = state.copyWith(
      pageName: TextEditingController(text: page.name),
      pageDescription: TextEditingController(text: page.description),
    );
  }
}

final createPageProvider = StateNotifierProvider<PageVm, PageState>((ref) {
  return PageVm(ref, PageRepository());
});

final singlePageProvider = StateNotifierProvider.family<PageVm, PageState, String>((ref, key) {
  return PageVm(ref, PageRepository());
});
