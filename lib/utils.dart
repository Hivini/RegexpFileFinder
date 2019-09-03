import 'dart:io';
import 'dart:async';

/// Given a [Directory], gets all the existing files paths recursively.
///
/// Throws [ArgumentError] if the directory does not exists or is null.
Future<List<String>> getAllFilesFromDirectory(Directory directory) async {
  if (directory == null || !(await directory.exists())) {
    throw ArgumentError('Invalid directory.');
  }
  var directoryList = directory.list(recursive: true);
  List<String> filePaths = [];
  await for (var entry in directoryList) {
    if (FileSystemEntity.isFileSync(entry.path)) {
      filePaths.add(entry.path);
    }
  }
  return filePaths;
}
