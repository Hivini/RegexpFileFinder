import 'dart:io';
import 'package:RegexpFolderFinder/utils.dart' as RegexpFolderFinder;

main(List<String> arguments) async {
  var filesPaths =
      await RegexpFolderFinder.getAllFilesFromDirectory(Directory.current);
  for (var file in filesPaths) {
    print(file);
  }
}
