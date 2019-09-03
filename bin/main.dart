import 'dart:io';
import 'dart:async';
import 'package:RegexpFolderFinder/utils.dart' as RegexpFolderFinder;
import 'package:RegexpFolderFinder/df_builder/state.dart';

main(List<String> arguments) async {
  var filesPaths =
      await RegexpFolderFinder.getAllFilesFromDirectory(Directory.current);
  for (var file in filesPaths) {
    print(file);
  }
}
