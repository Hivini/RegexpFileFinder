import 'dart:io';
import 'package:RegexpFolderFinder/utils.dart' as RegexpFolderFinder;
import 'package:RegexpFolderFinder/df_builder/regex_automaton.dart';

main(List<String> arguments) async {
  var filesPaths =
      await RegexpFolderFinder.getAllFilesFromDirectory(Directory.current);
  /*
  for (var file in filesPaths) {
    print(file);
  }*/
  RegexAutomaton automaton = RegexAutomaton('a*b+b');
}
