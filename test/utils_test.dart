import 'dart:io';
import 'package:RegexpFolderFinder/utils.dart' as RegexpFolderFinder;
import 'package:test/test.dart';

final String defaultTestPath = Directory.current.path + '/test_directory';

void main() {
  group('directory browser', () {
    final String testFolderPath = defaultTestPath + '/test1';
    final testDirectory = Directory(defaultTestPath);

    setUp(() {
      testDirectory.createSync();
      Directory(testFolderPath).createSync();
      File(defaultTestPath + '/rootFile.txt').createSync();
      File(testFolderPath + '/recursiveFile.txt').createSync();
    });

    tearDown(() {
      // Get rid of all created files for testing.
      testDirectory.delete(recursive: true);
    });

    String getResultingPath(String path) =>
        path.substring(defaultTestPath.length + 1);

    test('gets all the files from given directory', () async {
      var files = await RegexpFolderFinder.getAllFilesFromDirectory(
          Directory(defaultTestPath));
      expect(files.length, 2);
      expect(getResultingPath(files.elementAt(0)), 'rootFile.txt');
      expect(getResultingPath(files.elementAt(1)),
          'test1${Platform.pathSeparator}recursiveFile.txt');
    });
  });
}
