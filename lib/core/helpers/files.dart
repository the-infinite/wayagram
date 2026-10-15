import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';

class WayaFileExtensions {
  WayaFileExtensions._();

  /// An array containing a myriad of word document file extensions used for
  /// validating this file type.
  static const textDocuments = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'rtf',
    'odt',
  ];

  /// An array containing a myriad of spreadsheet file extensions used for
  /// validating this file type.
  static const spreadSheets = [
    'xls',
    'xlsx',
    'csv',
    'ods',
    'numbers',
    'tsv',
    'xlsm',
    'xlt',
    'xltx',
  ];

  /// An array containing a myriad of presentation document file extensions used
  /// for validating this file type.
  static const presentations = [
    'ppt',
    'pptx',
    'odp',
    'key',
    'pps',
    'ppsx',
  ];

  /// An array containing a myriad of archive file extensions used for validating
  /// this file type.
  static const archives = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'bz2',
    'xz',
    'iso',
    'tgz',
    'tbz2',
    'cab',
    'ace',
    'arj',
    'lzh',
    'lha',
    'wim',
  ];

  /// An array containing a myriad of markup file extensions used for validating
  /// this file type.
  static const markup = [
    'md',
    'json',
    'xml',
    'yaml',
    'yml',
    'toml',
    'ini',
    'html',
    'htm',
    'xhtml',
    'css',
    'scss',
    'sass',
    'less',
    'svg',
    'rss',
    'atom',
    'kml',
  ];

  /// An array containing a myriad of image file types.
  static const images = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'tif',
    'webp',
    'ico',
    'heic',
    'heif',
    'raw',
    'cr2',
    'nef',
    'arw',
    'dng',
  ];

  /// An array containing a myriad of video file types.
  static const videos = [
    'mp4',
    'avi',
    'mkv',
    'mov',
    'wmv',
    'flv',
    'webm',
    'mpeg',
    'mpg',
    'm4v',
    '3gp',
    'ts',
    'vob',
    'ogv',
    'rm',
    'rmvb'
  ];

  /// An array containing a myriad of audio file extensions used for validating
  /// this file type.
  static const audio = [
    'mp3',
    'wav',
    'aac',
    'ogg',
    'wma',
    'm4a',
    'flac',
    'aiff',
    'alac',
    'opus',
    'mid',
    'midi',
    'amr',
    'au',
    'ape',
    'aax',
    'ac3',
    'm4p',
    'mpc',
    'ra',
    'wv',
    '3ga',
    'dsf',
    'dsd'
  ];

  /// Returns the MIME type for a given file extension.
  ///
  /// Takes a file extension (without the dot) and returns the corresponding
  /// MediaType. If the extension is not recognized, returns application/octet-stream.
  static MediaType getMimeType(String fileExtension) {
    final ext = fileExtension.toLowerCase();

    // Documents
    if (['pdf'].contains(ext)) return MediaType('application', 'pdf');
    if (['doc', 'docx'].contains(ext)) return MediaType('application', 'msword');
    if (['txt'].contains(ext)) return MediaType('text', 'plain');
    if (['rtf'].contains(ext)) return MediaType('application', 'rtf');

    // Spreadsheets
    if (['xls', 'xlsx'].contains(ext)) return MediaType('application', 'vnd.ms-excel');
    if (['csv'].contains(ext)) return MediaType('text', 'csv');

    // Images
    if (['jpg', 'jpeg'].contains(ext)) return MediaType('image', 'jpeg');
    if (['png'].contains(ext)) return MediaType('image', 'png');
    if (['gif'].contains(ext)) return MediaType('image', 'gif');
    if (['webp'].contains(ext)) return MediaType('image', 'webp');
    if (['svg'].contains(ext)) return MediaType('image', 'svg+xml');

    // Videos
    if (['mp4'].contains(ext)) return MediaType('video', 'mp4');
    if (['webm'].contains(ext)) return MediaType('video', 'webm');
    if (['mpeg', 'mpg'].contains(ext)) return MediaType('video', 'mpeg');

    // Audio
    if (['mp3'].contains(ext)) return MediaType('audio', 'mpeg');
    if (['wav'].contains(ext)) return MediaType('audio', 'wav');
    if (['aac'].contains(ext)) return MediaType('audio', 'aac');
    if (['ogg'].contains(ext)) return MediaType('audio', 'ogg');

    // Archives
    if (['zip'].contains(ext)) return MediaType('application', 'zip');
    if (['rar'].contains(ext)) return MediaType('application', 'x-rar-compressed');

    // Markup
    if (['json'].contains(ext)) return MediaType('application', 'json');
    if (['xml'].contains(ext)) return MediaType('application', 'xml');
    if (['html', 'htm'].contains(ext)) return MediaType('text', 'html');
    if (['css'].contains(ext)) return MediaType('text', 'css');

    // Default fallback for unknown types
    return MediaType('application', 'octet-stream');
  }

  /// Extracts the file extension from a given file path string.
  ///
  /// Returns the extension without the dot, or an empty string if no extension is found.
  /// Example:
  ///   WayaFileExtensions.getExtensionFromPath('example/file.txt'); // returns 'txt'
  static String getExtensionFromPath(String path) {
    final filename = path.split(Platform.pathSeparator).last;
    final extensionIndex = filename.lastIndexOf(".");
    return extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
  }
}

class WayaFileHelper {
  WayaFileHelper._();

  /// Returns the number as a size in the largest possible unit.
  static String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Returns a helper used to calculate the the downloads directory.
  static Future<Directory?> getDownloadedFilesDirectory() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      // Error handled silently
    }

    //? This is fine.
    if (directory == null) {
      return null;
    }

    //? If this does not exist...
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? We can tent.
    return directory;
  }

  /// Returns the base storage directory for the application.
  ///
  /// This is an asynchronous method that resolves to a [Directory] object
  /// representing the root storage location where application files will be
  /// stored.
  ///
  /// Throws a [PlatformException] if the storage directory cannot be accessed.
  static Future<Directory> _getBaseStorageDirectory() async {
    //? This is fine.
    var directory = await getApplicationDocumentsDirectory();

    //?  If this is Android.
    // if (Platform.isAndroid) {
    //   directory = Directory("${(await getExternalStorageDirectory())!.parent.parent.parent.path}/media/ng.wayagram");
    // }

    //? If this does not exist...
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory;
  }

  /// Get the directory where the app always stores downloaded documents.
  ///
  /// This asynchronous method returns a [Directory] representing the device's
  /// document storage location where the application can store and access downloaded files.
  /// The exact location varies by platform:
  /// * On Android: Internal storage/Android/data/your.package.name/files
  /// * On iOS: Application Documents directory
  ///
  /// Returns a [Future<Directory>] that resolves to the documents directory.
  static Future<Directory> getDocumentsDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Documents/Sent");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a Future that resolves to the media storage directory for the
  /// application.
  ///
  /// The media directory is used for storing various media files like images,
  /// videos, and other media content used by the application. This is where all
  /// the downloaded media by users should go to.
  ///
  /// This is an asynchronous operation that needs to be awaited when called.
  ///
  /// Returns:
  ///   * [Directory] - A [Future<Directory>] pointing to the media storage location
  static Future<Directory> getMediaDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Media/Sent");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a Future that resolves to the media storage directory for the
  /// application.
  ///
  /// The media directory is used for storing various media files like images,
  /// videos, and other media content used by the application. This is where all
  /// the downloaded media by users should go to.
  ///
  /// This is an asynchronous operation that needs to be awaited when called.
  ///
  /// Returns:
  ///   * [Directory] - A [Future<Directory>] pointing to the media storage location
  static Future<Directory> getReportsDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Debug");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a Future that resolves to the audio storage directory for the
  /// application.
  ///
  /// The audio directory is used for storing various media files like images,
  /// videos, and other media content used by the application. This is where all
  /// the downloaded media by users should go to.
  ///
  /// This is an asynchronous operation that needs to be awaited when called.
  ///
  /// Returns:
  ///   * [Directory] - A [Future<Directory>] pointing to the media storage location
  static Future<Directory> getAudioDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Audio/Sent");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a [Directory] object representing the directory where voice messages
  /// are stored.
  ///
  /// This function asynchronously retrieves or creates a dedicated directory for
  /// storing voice message files in the application's storage space.
  ///
  /// Returns a [Future] that completes with the [Directory] instance.
  ///
  /// Throws [IOException] if the directory cannot be accessed or created.
  static Future<Directory> getVoiceMessagesDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/VoiceMessages/Sent");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a [Directory] containing status updates
  ///
  /// This asynchronous method retrieves the directory where status updates are stored.
  /// The directory is used to manage and access user's status update files.
  ///
  /// Returns a [Future] that resolves to the status updates [Directory].
  static Future<Directory> getStatusUpdatesDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/StatusUpdates/Sent");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a [Directory] instance representing the path to the databases directory.
  ///
  /// This method asynchronously retrieves the directory where database files should be stored.
  /// The returned [Future] completes with a [Directory] object pointing to the databases path.
  ///
  /// Throws a [PlatformException] if the directory cannot be accessed or created.
  static Future<Directory> getDatabasesDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Databases");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns a Directory object representing the backups directory for the application.
  ///
  /// The directory path is platform-specific and follows standard backup storage conventions.
  /// This method is asynchronous and returns a Future that resolves to the Directory object.
  ///
  /// Example:
  /// ```dart
  /// Directory backupDir = await Files.getBackupsDirectory();
  /// ```
  static Future<Directory> getBackupsDirectory() async {
    final base = await _getBaseStorageDirectory();
    var directory = Directory("${base.absolute.path}/Backups");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory.parent;
  }

  /// Returns the file path for a voice note associated with a specific chat.
  ///
  /// Takes a [chatId] parameter to uniquely identify the chat context.
  /// Creates a directory for voice notes if it doesn't exist and generates
  /// a unique file path for storing the voice note.
  ///
  /// Returns a [Future<String>] with the complete file path where the voice
  /// note should be stored.
  static Future<String> getVoiceNoteFilePath(String chatId) async {
    final directory = await getVoiceMessagesDirectory();

    // Then return this bonkers generated file path.
    return "${directory.absolute.path}/Sent/${chatId}_${WayaValueHelper.createUid()}.m4a";
  }

  /// A helper function used to generate a name for a given file in a chat.
  static String generateFilename(String chatId, File original) {
    final filename = original.uri.pathSegments.last;
    final extensionIndex = filename.lastIndexOf(".");
    final ext = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
    return "${chatId}_${WayaValueHelper.createUid()}.$ext".replaceAll("-", "_");
  }

  /// Returns the final directory of a file using the logic of where we are coming
  static String getFileSubdirectory(Directory parent, String senderId) {
    return "${parent.absolute.path}${senderId == ConversationState.self.id ? "/Sent" : ""}";
  }

  /// A helper function used to calculate the directory of the file for a given
  /// message.
  static Future<File> getFileDirectory(MessageModel message, MessageMediaModel file) async {
    final uri = Uri.parse(file.mediaUrl);
    final filename = uri.pathSegments.last;
    final extensionIndex = filename.lastIndexOf(".");
    final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
    var directory = await WayaFileHelper.getDocumentsDirectory();

    //? Now, we check what kind of extension this is.
    if ([...WayaFileExtensions.images, ...WayaFileExtensions.videos].contains(extension)) {
      directory = await WayaFileHelper.getMediaDirectory();
    }

    //? If this is an audio file.
    if (WayaFileExtensions.audio.contains(extension)) {
      directory = await WayaFileHelper.getAudioDirectory();
    }

    //? Now, we try looking for the rest here.
    final path = "${WayaFileHelper.getFileSubdirectory(directory, message.senderId)}/$filename";

    // Now, return this file.
    return File(path);
  }

  /// A helper function used to get the extension of a file.
  static String getFileExtension(String path) {
    final uri = path.split(Platform.pathSeparator);
    final filename = uri.last;
    final extensionIndex = filename.lastIndexOf(".");
    return extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
  }

  /// A helper function used to calculate the directory where we would keep a
  /// status update.
  static Future<File> getMomentDirectory(MomentData moment, String file) async {
    final uri = File(file);
    final filename = uri.uri.pathSegments.last;
    final extensionIndex = filename.lastIndexOf(".");
    final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
    var directory = await WayaFileHelper.getStatusUpdatesDirectory();

    //? Now, we try looking for the rest here.
    final path =
        "${WayaFileHelper.getFileSubdirectory(directory, moment.userId)}/${moment.id.replaceAll("-", "")}.$extension";

    // Now, return this file.
    return File(path);
  }

  /// A helper function used to calculate the directory of the file for a given
  /// message.
  static Future<File> getFileLocalDirectory(MessageModel message, String file) async {
    final uri = File(file);
    final filename = uri.uri.pathSegments.last;
    final extensionIndex = filename.lastIndexOf(".");
    final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
    var directory = await WayaFileHelper.getDocumentsDirectory();

    //? Now, we check what kind of extension this is.
    if ([...WayaFileExtensions.images, ...WayaFileExtensions.videos].contains(extension)) {
      directory = await WayaFileHelper.getMediaDirectory();
    }

    //? If this is an audio file.
    if (WayaFileExtensions.audio.contains(extension)) {
      directory = await WayaFileHelper.getAudioDirectory();
    }

    //? Now, we try looking for the rest here.
    final path = "${WayaFileHelper.getFileSubdirectory(directory, message.senderId)}/$filename";

    // Now, return this file.
    return File(path);
  }

  // helper method for saving file from online to user gallery
  // call the method passing in the video url
  // returns true when successful and false when it fails
  static Future<bool> saveNetworkVideo(
    String videoPath, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    return await GallerySaver.saveVideo(videoPath, albumName: albumName, toDcim: toDcim, headers: headers) ?? false;
  }

  // helper method for saving file from online to user gallery
  // call the method passing in the image url
  // returns true when successful and false when it fails
  static Future<bool> saveNetworkImage(
    String imagePath, {
    String? albumName,
    bool toDcim = false,
    Map<String, String>? headers,
  }) async {
    return await GallerySaver.saveImage(imagePath, albumName: albumName, toDcim: toDcim, headers: headers) ?? false;
  }
}
