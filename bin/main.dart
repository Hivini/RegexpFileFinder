import 'dart:io';
import 'dart:async';
import 'package:RegexpFolderFinder/RegexpFileFinder.dart' as RegexpFolderFinder;

main(List<String> arguments) async {
  var filesPaths =
      await RegexpFolderFinder.getAllFilesFromDirectory(Directory.current);
  for (var file in filesPaths) {
    print(file);
  }
}
