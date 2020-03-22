import 'dart:convert';
import 'dart:io';
import 'package:RegexpFolderFinder/utils.dart' as RegexpFolderFinder;
import 'package:RegexpFolderFinder/df_builder/regex_automaton.dart';

main(List<String> arguments) async {
  var files = await RegexpFolderFinder.getFiles(
      Directory(Directory.current.path + '${Platform.pathSeparator}vini'));
  for (var file in files.entries) {
    print("${file.value} directory --> ${file.key}");
  }
  RegexAutomaton automaton;
  var loop = true;
  while(loop) {
    print('\n1.- Enter regexp\n2.- Do operations\n3.- Exit');
    var selected = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
    switch(selected) {
      case '1':
        print('Enter regexp:');
        var regexp = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
        automaton = RegexAutomaton(regexp);
        print('Automaton created.');
        break;
      case '2':
        for (var file in files.entries) {
          if (automaton.isValid(file.value)) {
            printFile('Title', file.value, file.key);
          }
          var validWords = fileValid(automaton, file.key);
          if (validWords.isNotEmpty) {
            printFile('Contents', file.value, file.key);
            for (var word in validWords) {
              print('\t$word');
            }
          }
        }
        break;
      case '3':
        loop = false;
        break;
      default:
        print('Careful! This is the only validation of the whole program.');
        break;
    }
  }
  print('Sadness = Kleen closure');
}

void printFile(String foundBy, String fileName, String filePath) =>
    print('$foundBy : $fileName --> $filePath');

List<String> fileValid(RegexAutomaton automaton, String filePath) {
  var validWords = List<String>();
  File file = File(filePath);
  List<String> lines = file.readAsLinesSync();
  for (var line in lines) {
    for (var word in line.split(" ")) {
      if (automaton.isValid(word)) {
        validWords.add(word);
      }
    }
  }
  return validWords;
}


