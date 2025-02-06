import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/pages/data/model/feeds.dart';
import 'package:wayagram/features/pages/data/model/followers_model.dart';
import 'package:wayagram/features/pages/data/model/page_state.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/media_upload_model.dart';
import 'package:wayagram/features/post/model/saved_posts.dart';
import 'package:http/http.dart' as http;
import '../../post/model/comment.dart';

class UploadedImage {
  final String url;
  final String file;
  final String fileName;

  UploadedImage({required this.url, required this.file, required this.fileName});
}

class PageVm extends StateNotifier<PageState> {
  final Ref ref;
  final PageRepository _pageRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final ImagePicker _picker;

  final _logger = getLogger('PageVm');

  PageVm(
    this.ref,
    this._picker,
    this._pageRepository,
    this._localDataSource,
    this._secureDataSource,
  ) : super(PageState()) {
    state = state.copyWith(pageName: TextEditingController(text: ''));
    state = state.copyWith(pageDescription: TextEditingController(text: ''));
    state = state.copyWith(content: TextEditingController(text: ''));
  }

  void reset() {
    state = PageState();
  }

  String _errorMessage = '';
  int _totalPages = 0;

  String get errorMessage => _errorMessage;
  int get totalPages => _totalPages;

  final List<SavedPost> _savedPosts = [];
  String _errorMessage2 = '';
  List<SavedPost> get savedPosts => _savedPosts;
  String get errorMessage2 => _errorMessage2;

  Future<void> commentPost2(Post post) async {
    if (post.id != null) {
      //Get.to(() => FullPostDetailsScreen(post: post));
    } else {
      print('ERROR: Post ID is null!!!');
    }
  }

  Future<void> likePost(Post post, {String? reaction}) async {
    post.toggleLike(); // Toggle local like state
    updateValue(post.isLikedCount, post.getIsLiked().value == true);
    WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();
    if (post.id != null) {
      final user = _wayaLocalDataSource.getUser().user;

      if (user == null) {
        //showError('Getting user profile... try again');
        return;
      }

      if (reaction != null) {
        // If a reaction is provided, update it
        final response = await _pageRepository.reactOnPost(post.id!, reaction);
        if (response.success) {
          post.reactions[user.id!] = response.data!.reactions[user.id!]!;
          //..userId = Author(id: user.id,firstName: user.firstName ?? '',lastName: user.lastName ?? '');
        }
        handleLikeResponse(post, response);
      } else if (post.getIsLiked().value == true) {
        // Handle default "like" without specific reaction
        final response = await _pageRepository.reactOnPost(post.id!, 'like');
        handleLikeResponse(post, response);
      } else {
        // Remove like if toggled off
        final response = await _pageRepository.removeReaction(post.id!, post.getReactionId(user.id!));
        handleLikeResponse(post, response);
      }
    } else {
      print('ERROR: Post ID is null!!!');
    }
  }

  void handleLikeResponse(Post post, WayaRequestResponse response) {
    if (response.success) {
      post.toggleLike();
      updateValue(post.isLikedCount, post.getIsLiked().value == true);
      //showError(response.message);
    }
  }

  void updateValue(RxInt value, bool isIncreased) {
    if (isIncreased) {
      value.value++;
    } else {
      value.value--;
    }
  }

  Future<void> unsavePost(BuildContext context, String postId) async {
    try {
      print('Attempting to unsave post with ID: $postId');
      final response = await _pageRepository.delete(postId);

      if (response.statusCode == 200) {
        print('Post Unsaved successfully.');
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
        print('Failed to unsave post: ${response.data}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error unsaving post. Try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      print('Error unsaving post: $error');
    }
  }

  //save post
  Future<void> savePost(BuildContext context, postId) async {
    try {
      final response = await _pageRepository.savePost(postId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Post saved successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post saved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Failed to save post. Status code: ${response.statusCode}');
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
      print('Error saving post: $e');
    }
  }

  Future<void> fetchSavedPosts(userId) async {
    print('Fetching saved posts...');

    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.fetchPost(userId);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        FetchAllPost responseModel = FetchAllPost.fromJson(response.data);
        state = state.copyWith(fetchAllPostData: responseModel.data?.docs);
        // final data = SavedPostsResponse.fromJson(response.data);

        //print('Data parsed: ${data.savedPosts.length} saved posts received.');

        // Clear existing saved posts
        _savedPosts.clear();

        // Add new saved posts if available
        /*if (data.savedPosts.isNotEmpty) {
          _savedPosts.addAll(data.savedPosts); // No need to map, just add the SavedPost directly
          print('Saved posts added: ${_savedPosts.length} posts.');
        } */
      } else {
        print('Error: Status code ${response.statusCode}');
        _errorMessage2 = 'Failed to fetch saved posts. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception occurred while fetching saved posts: $e');
      _errorMessage2 = 'Something went wrong. Please try again later.';
    } finally {
      // _isLoading = false;
      // notifyListeners();
      //print('Saved posts fetch completed. Loading state: $_isLoading');
    }
  }

  Future<void> createPost(ctx, content, postType, List<XFile> images) async {
    print("before the loop");
    List<UploadedImage> urls = [];
    final choiceMap = <String>[];
    // get url
    for (XFile image in images) {
      print("In the loop ${image.name} ${image.path} ${image.mimeType}");

      final uploadImageResponse = await _pageRepository.getUploadImage(image.name);

      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
    }

    //MultipartFile.fromPath('file', file.path)

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

      //? This is fine.
      print("Data ${putImageResponse.data}");
    }
    //WayaHelpers.

    try {
    //   final response = await _pageRepository.createPost(content, choiceMap, postType);

    //   //? If this is fine...
    //   if (response.success && ctx.mounted) {
    //     ScaffoldMessenger.of(ctx).showSnackBar(
    //       const SnackBar(
    //         content: Text('Post created successfully!'),
    //         backgroundColor: WayaColors.primary,
    //         duration: Duration(seconds: 2),
    //       ),
    //     );
    //   }

    //   //? If it failed...
    //   else {
    //     _logger.i('LOGGER  ==>>> ${response.data['error']}');
    //     print('Create post');
    //     _logger.i(response.data['data']);
    //   }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> commentPost(String postId, String content) async {
    try {
      final data = {"content": content};
      final response = await _pageRepository.commentOnPost(postId, data);
      if (response!.statusCode == 200 || response.statusCode == 201) {
        // _isLoading = false;

        return true;
      } else {
        //_isLoading = false;
        _errorMessage = 'Failed to post comment';

        return false;
      }
    } on DioException catch (e) {
      print("Error: $e");

      return false;
    }
  }

  FutureOr<List<Comments>> getComments(String id) async {
    //_isLoading = true;
    _errorMessage = '';
    //notifyListeners();

    try {
      //final token = await Store.getToken();
      //final dio = Dio();

      final response = await _pageRepository.getComment(id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print("uri: ${response.realUri}");
        print("Post comments ${response.data}");
        final data = response.data["comments"] as List;

        final comment = data.map((json) => Comments.fromJson(json)).toList();
        // _isLoading = false;

        return comment;
      } else {
        //_isLoading = false;
        _errorMessage = 'Failed to fetch comment';

        return [];
      }
    } on DioException catch (e) {
      print("Error: $e");
      //_isLoading = false;
      _errorMessage = e.toString();

      rethrow;
    } finally {}
  }

  Stream<List<Comments>> getCommentsStream(String postId) {
    return Stream.periodic(const Duration(seconds: 5), (count) async {
      //final token = await Store.getToken();

      final response = await _pageRepository.getComment(postId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data["comments"];
        return data.cast<Map<String, dynamic>>().map((json) => Comments.fromJson(json)).toList();
      } else {
        return [];
      }
    }).asyncMap((_) => getComments(postId));
  }

  Future<void> getFollowing() async {
    state = state.copyWith(isLoading: true);
    final response = await _pageRepository.getFollowing();
    state = state.copyWith(isLoading: false);
    if (response.success) {
      FollowersModel responseModel = FollowersModel.fromJson(response.data);
      //state = state.copyWith(fetchAllPols: responseModel.data?.docs);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

final pageProvider = Provider((ref) => PageRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createPageProvider = StateNotifierProvider<PageVm, PageState>((ref) {
  final pageRepository = ref.watch(pageProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return PageVm(
    ref,
    ImagePicker(),
    pageRepository,
    localDataSource,
    WayaSecureDataSource(),
  );
});



// Future<void> createPost(ctx,content, postType, String image) async {
//
//   final List<String> choiceMap = [image];
//
//   for (var i = 0; i < state.images.length; i++) {
//     await MultipartFile.fromFile(state.images[i].image!.path, contentType: MediaType.parse('image/*'));
//   }
//
//   try {
//     state = state.copyWith(isLoading: true);
//     final response = await _pageRepository.createPost(content, choiceMap, postType);
//     state = state.copyWith(isLoading: false);
//     Navigator.of(ctx).pop();
//     if (response.success && ctx.mounted) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('Post created successfully!'),
//           backgroundColor: WayaColors.primary,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       _logger.i(response.data['data']);
//     }else{
//       _logger.i('LOGGER  ==>>> ${response.data['error']}');
//       print('CHECKINGGGGG');
//     }
//   } catch (e) {
//     _logger.e(e);
//   } finally {
//     state = state.copyWith(isLoading: false);
//   }
// }
//