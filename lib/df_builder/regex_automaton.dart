import 'package:RegexpFolderFinder/df_builder/state.dart';

/// Class that creates a graph to evaluate simple regular expressions.
class RegexAutomaton {
  State _startState;

  State _endState;

  String regexp;

  RegexAutomaton(this.regexp) {
    _startState = State();
    _endState = State(endState: true);
    createGraph();
  }

  void createGraph() {
    // TODO: Create the actual graph based on [regexp].
  }
}