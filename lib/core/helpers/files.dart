import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:wayagram/core/helpers/value.dart';

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
}

class WayaFileHelper {
  WayaFileHelper._();

  /// Returns the base storage directory for the application.
  ///
  /// This is an asynchronous method that resolves to a [Directory] object
  /// representing the root storage location where application files will be
  /// stored.
  ///
  /// Throws a [PlatformException] if the storage directory cannot be accessed.
  static Future<Directory> _getBaseStorageDirectory() async {
    var directory = Directory("${(await getApplicationDocumentsDirectory()).absolute.path}/WayaGram");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? Since we now know this exists...
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
    var directory = Directory("${base.absolute.path}/Documents");

    //? Then print this out.
    if (!await directory.exists()) {
      directory = await directory.create(recursive: true);
    }

    //? This is fine.
    return directory;
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
    return "${directory.absolute.path}/${chatId}_${WayaValueHelper.createUid()}.aac";
  }
}
