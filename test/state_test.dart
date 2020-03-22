import 'package:RegexpFolderFinder/df_builder/state.dart';
import 'package:test/test.dart';

void main() {
  group(State, () {
    State rootState = State('rt');

    group('from transitions', () {
      State nextState = State('ns');

      test('adds new entries with single characters as key', () {
        rootState.addTransition('a', nextState);
        rootState.addTransition('b', nextState);
        expect(rootState.getStateFromSymbol('a'), nextState);
        expect(rootState.getStateFromSymbol('b'), nextState);
      });

      test('throws error if not single character key symbol is entered', () {
        expect(() => rootState.addTransition('ab', nextState),
            throwsA(TypeMatcher<ArgumentError>()));
      });

      test('throws error if thekey does not exist on the transitions', () {
        expect(() => rootState.getStateFromSymbol('ab'),
            throwsA(TypeMatcher<ArgumentError>()));
      });
    });
  });
}
