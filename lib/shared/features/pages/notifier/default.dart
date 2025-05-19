import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/data/model/pages_users_follow_model.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class PageNotifier extends ValueNotifier<int> {
  final int limit = 3000;
  final repo = PageRepository();
  bool isLoading = false;
  int createdPage = 1;
  int followedPage = 1;
  bool hasMoreCreatedPages = true;
  bool hasMoreFollowedPages = true;
  int totalCreatedPages = 0;
  int totalJoinedPages = 0;
  List<PageModel> createdPages = [];
  List<PageModel> followedPages = [];
  List<PostModel> popularPosts = [];
  List<PostModel> latestPosts = [];
  List<PostModel> recentPosts = [];

  // This is fine.
  PageNotifier._() : super(0);

  /// Retrieves all pages associated with a specific user
  ///
  /// Takes a [userId] as parameter and returns a Future containing a List of [PageModel]
  /// objects representing all pages owned by or accessible to the specified user.
  ///
  /// Throws an exception if the operation fails or if the user is not authenticated.
  Future<List<PageModel>> getCreatedPages() async {
    final result = <PageModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreCreatedPages) return createdPages;

    //? If is now loading.
    isLoading = true;

    //? Refresh.
    refresh();

    //? Now, try actually fetching the groups.
    try {
      final response = await repo.getAllPages(ConversationState.self.id, createdPage, limit);

      //? If this was successful.
      if (!response.success) return createdPages;

      //? Then continue onward.
      final responseModel = PagesUsersFollowModel.fromJson(response.data);

      //? If there were older pages to this thing...
      if (createdPage > 1) {
        result.addAll(createdPages);
      }

      //? This is good.
      totalCreatedPages = responseModel.data?.totalDocs?.toInt() ?? 0;
      createdPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreCreatedPages = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched groups.
      result.addAll(responseModel.data?.docs ?? []);
      wayaPageCache.cacheAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      createdPages = result;
      isLoading = false;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }


  Future<List<PageModel>> getManagedPages() async {

    final result = <PageModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreCreatedPages) return createdPages;

    //? If is now loading.
    isLoading = true;

    //? Refresh.
    refresh();

    //? Now, try actually fetching the groups.
    try {
      final response = await repo.getAllManagedPages( createdPage, limit);

      //? If this was successful.
      if (!response.success) return createdPages;

      //? Then continue onward.
      final responseModel = PagesUsersFollowModel.fromJson(response.data);

      //? If there were older pages to this thing...
      if (createdPage > 1) {
        result.addAll(createdPages);
      }

      //? This is good.
      totalCreatedPages = responseModel.data?.totalDocs?.toInt() ?? 0;
      createdPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreCreatedPages = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched groups.
      result.addAll(responseModel.data?.docs ?? []);
      wayaPageCache.cacheAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      createdPages = result;
      isLoading = false;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }

  /// Retrieves a list of pages that the current user follows.
  ///
  /// Makes an asynchronous request to fetch all the pages that the authenticated
  /// user is currently following. Returns a [Future] that resolves to a [List]
  /// of [PageModel] objects.
  ///
  /// Returns:
  ///   * [Future<List<PageModel>>] A future that resolves to a list of page models
  ///     representing the pages followed by the user.
  Future<List<PageModel>> getPagesUserFollows() async {
    final result = <PageModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreFollowedPages) return followedPages;

    //? Now, try.
    try {
      final response = await repo.getPagesAUserFollows(followedPage, limit);

      //? If this was successful.
      if (!response.success) return followedPages;

      //? Then continue onward.
      final responseModel = PagesUsersFollowModel.fromJson(response.data);

      //? If there were older pages to this thing...
      if (followedPage > 1) {
        result.addAll(followedPages);
      }

      //? This is good.
      totalJoinedPages = responseModel.data?.totalDocs?.toInt() ?? 0;
      followedPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreFollowedPages = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched pages.
      wayaPageCache.cacheAll(responseModel.data?.docs ?? []);
      result.addAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      followedPages = result;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }

  /// Creates a new page in the application.
  ///
  /// Takes necessary page information and persists it to the backend.
  /// Returns a [PageModel] object containing the created page's data if successful,
  /// or `null` if the operation fails.
  ///
  /// Throws an exception if there are network connectivity issues or
  /// if the server returns an error response.
  Future<PageModel?> createPage(
    String pageName,
    String pageDesc,
    bool pageType,
    String coverImage,
    String profileImage,
  ) async {
    final coverImageUrl = await WayaFileRepository.instance.uploadFile(File(coverImage));
    final profileImageUrl = await WayaFileRepository.instance.uploadFile(File(profileImage));

    //? If either of this fails.
    if (coverImageUrl == null || profileImageUrl == null) {
      WayaSnackBar.showToast("Sorry, we cannot upload your page at this time.", showSuccess: false);
      return null;
    }

    try {
      final response = await repo.createPage(pageName, pageDesc, pageType, coverImageUrl, profileImageUrl);

      //? If this was fine...
      if (response.success) {
        final result = PageModel.fromJson(response.data['data']);
        createdPages.insert(0, result);
        wayaPageCache.cache(result.id, result);
        refresh();
        WayaSnackBar.showToast("Page created successfully");
        return result;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return null;
  }

  /// Modifies an existing page's information.
  ///
  /// Returns a [Future] that completes with a [bool] indicating whether
  /// the page edit operation was successful (true) or failed (false).
  Future<bool> editPage(
    String pageName,
    String pageDesc,
    bool pageType,
    String coverImage,
    String profileImage,
    String pageId,
  ) async {
    final coverImageUrl =
        coverImage.startsWith("http") ? coverImage : await WayaFileRepository.instance.uploadFile(File(coverImage));
    final profileImageUrl = profileImage.startsWith("http")
        ? profileImage
        : await WayaFileRepository.instance.uploadFile(File(profileImage));

    //? If either of this fails.
    if (coverImageUrl == null || profileImageUrl == null) {
      WayaSnackBar.showToast("Sorry, we cannot upload your page at this time.", showSuccess: false);
      return false;
    }

    try {
      final response = await repo.editPage(pageName, pageDesc, pageType, coverImageUrl, profileImageUrl, pageId);

      //? If this is fine...
      if (response.success) {
        final result = PageModel.fromJson(response.data["data"]);
        final found = createdPages.indexWhere((group) => group.id == pageId);
        wayaPageCache.cache(result.id, result);

        //? If this was found, remove it and update.
        if (!found.isNegative) {
          createdPages[found] = result;
          refresh();
        }
      }

      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  /// Deletes a page with the specified page ID from the system.
  ///
  /// This asynchronous operation removes all associated page data.
  ///
  /// Parameters:
  ///   - pageId: The unique identifier of the page to be deleted.
  ///
  /// Throws:
  ///   - Exception if the page deletion fails.
  Future<bool> deletePage(String pageId) async {
    try {
      final response = await repo.deletePage(pageId);

      //? This is fine.
      if (response.success) {
        final found = createdPages.indexWhere((group) => group.id == pageId);
        wayaPageCache.deleteItem(pageId);

        //? If this was found, remove it and update.
        if (!found.isNegative) {
          createdPages.removeAt(found);
          refresh();
        }

        //? Now report.
        WayaSnackBar.showToast("Page deleted successfully");
      }

      //? Good.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? No.
    return false;
  }

  /// Follows a specific page using its ID.
  ///
  /// Takes a [pageId] as a parameter which uniquely identifies the page to follow.
  /// Returns a [Future<bool>] that resolves to true if the follow operation was successful,
  /// false otherwise.
  ///
  /// Throws an exception if the follow operation fails or if the pageId is invalid.
  Future<bool> followPage(String pageId) async {
    try {
      final response = await repo.followPage(pageId);

      //? Since you joined this group all good and fine.
      if (response.success) {
        resetFollowedPages(false);
        await getPagesUserFollows();
        await getSinglePage(pageId);
        WayaSnackBar.showToast("Followed the page successfully");
      }

      // Return the success status.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return false.
    return false;
  }

  /// Retrieves a single page from the database using its unique identifier.
  ///
  /// Parameters:
  /// - [pageId]: The unique identifier string of the page to retrieve.
  ///
  /// Returns a [Future] that completes with a [PageModel] instance if the page is found,
  /// or `null` if no page exists with the given ID.
  ///
  /// Throws an exception if there's an error during the database operation.
  Future<PageModel?> getSinglePage(String pageId) async {
    try {
      // API call
      final response = await repo.getSinglePage(pageId);

      if (response.success) {
        final responseModel = PagesUsersFollowModel.fromJson(response.data);
        wayaPageCache.cacheAll(responseModel.data?.docs ?? []);
        return responseModel.data?.docs?.first;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return null.
    return null;
  }

  /// Refreshes the specified post's data asynchronously.
  ///
  /// This method updates the state of a post identified by [postId] with the latest data.
  ///
  /// Parameters:
  ///   * [postId] - The unique identifier of the post to be refreshed.
  ///
  /// Throws an error if the refresh operation fails.
  Future<void> refreshPost(String postId) async {
    try {
      // API call
      final response = await repo.fetchSinglePost(postId);

      if (response.success) {
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  /// Unfollows a page with the specified ID.
  ///
  /// Takes a [pageId] as a parameter which uniquely identifies the page to unfollow.
  /// Returns a [Future<bool>] that resolves to:
  /// * `true` if the unfollow operation was successful
  /// * `false` if the operation failed
  ///
  /// Throws an exception if the unfollow operation encounters an error.
  Future<bool> unfollowPage(String pageId) async {
    try {
      final response = await repo.unFollowPage(pageId);

      //? If this was fine.
      if (response.success) {
        final found = followedPages.indexWhere((page) => page.id == pageId);

        //? If this was found, remove it and update.
        if (!found.isNegative) {
          followedPages.removeAt(found);
          refresh();
        }

        //? Then this is fine.
        await getSinglePage(pageId);

        //? Notify the user.
        WayaSnackBar.showToast("You have unfollowed the page");
      }

      // Return the success status.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This failed.
    return false;
  }

  /// Controller function used to reset the ENTIRE thing such that we fetch new
  /// data once more.
  void reset() {
    resetFollowedPages(false);
    resetCreatedPages();
  }

  /// Controller function used to reset the followed pages state so that we have
  /// a clean slate there.
  void resetFollowedPages([bool refresh = true]) {
    followedPage = 1;
    hasMoreFollowedPages = true;
    totalJoinedPages = 0;
    followedPages = [];

    //? Refresh if needed.
    if (refresh) this.refresh();
  }

  /// Controller function used to reset the created pages state so that we have
  /// a clean slate there.
  void resetCreatedPages([bool refresh = true]) {
    createdPage = 1;
    hasMoreCreatedPages = true;
    totalCreatedPages = 0;
    createdPages = [];

    //? Refresh if needed.
    if (refresh) this.refresh();
  }

  /// Utility function used to check whether or not a user is a member of a
  /// page.
  bool isMemberOf(String pageId) {
    return followedPages.any((page) => page.id == pageId) || createdPages.any((page) => page.id == pageId);
  }

  /// Refreshes the current state and triggers a rebuild of dependent widgets.
  ///
  /// This method is used to force update the group-related data and UI elements
  /// when changes occur in the group state.
  void refresh() {
    value = value + 1;
  }
}

final myPageNotifier = PageNotifier._();
