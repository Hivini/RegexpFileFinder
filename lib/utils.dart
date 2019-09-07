import 'dart:async';
import 'dart:collection';
import 'dart:io';

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

String getChar(String word, int index) =>
    String.fromCharCode(word.codeUnitAt(index));

String orderOperation(String regexp) {
  if (regexp == '') {
    return '';
  }
  // The queue class can behave like a stack.
  var stack = Queue<String>();
  var result = "";
  for (int i = 0; i < regexp.length; i++) {
    var char = getChar(regexp, i);
    if (char == '(') {
      if (stack.isNotEmpty) {
        result += stack.removeLast();
      }
      int index = i + 1;
      var subRegexp = getParenthesisExpression(regexp, index);
      index += subRegexp.length;
      if (index != regexp.length - 1) {
        if (getChar(regexp, index + 1) == '*') {
          result += '*';
          index++;
        }
      }
      result += char + orderOperation(subRegexp) + ')';
      i = index;
    } else if (char == '*') {
      result += char;
      result += stack.removeLast();
    } else if (char == '+') {
      result += char;
      result += stack.removeLast();
      result += getChar(regexp, i + 1);
      i++;
    } else {
      if (stack.isEmpty) {
        stack.addLast(char);
      } else {
        result += stack.removeLast();
        stack.addLast(char);
      }
    }
  }
  if (stack.isNotEmpty) {
    result += stack.removeLast();
  }
  return result;
}

String getParenthesisExpression(String regexp, int startIndex) {
  int leftParenthesis = 0;
  var currentChar = '';
  var subRegexp = '';
  while (startIndex != regexp.length + 1) {
    currentChar = getChar(regexp, startIndex);
    if (currentChar == '(') {
      leftParenthesis++;
    } else if (currentChar == ')') {
      if (leftParenthesis == 0) {
        break;
      } else {
        leftParenthesis--;
      }
    }
    subRegexp += currentChar;
    startIndex++;
  }
  return subRegexp;
}
