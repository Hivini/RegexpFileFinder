import 'package:RegexpFolderFinder/df_builder/state.dart';
import 'package:RegexpFolderFinder/utils.dart';

class NonDeterministicAutomaton {
  static int stateNum = 1;

  State _startState;

  State _endState;

  String _regexp;

  NonDeterministicAutomaton({String regexp, State startState, State endState}) {
    this._regexp = regexp ?? '';
    this._startState = startState ?? State('q0');
    this._endState = endState ?? State('qf');
  }

  NonDeterministicAutomaton generateGraph() {
    var nda = process(this.regexp);
    nda.endState.endState = true;
    return nda;
  }

  NonDeterministicAutomaton process(regexp) {
    NonDeterministicAutomaton nda = NonDeterministicAutomaton();
    for (int i = 0; i < regexp.length; i++) {
      var char = getChar(regexp, i);
      if (char == '(') {
        String exp = getParenthesisExpression(regexp, i + 1);
        var length = i + exp.length + 1;
        var newNda;
        if (length < regexp.length-1 && getChar(regexp, length + 1) == '*') {
          newNda = doOperation(process(exp), '*');
          // Skip the expression after the ) and the *.
          if (nda.regexp == '') {
            nda = newNda;
          } else {
            nda = doOperation(nda, null, newNda);
          }
          i += exp.length + 2;
        } else {
          newNda = process(exp);
          if (nda.regexp == '') {
            nda = newNda;
          } else {
            doOperation(nda, null, newNda);
          }
          // Continue the expression after the ')'.
          i += exp.length + 1;
        }
      } else if (char == '*') {
        nda = doOperation(nda, '*');
      } else if (char == '+') {
        nda = doOperation(nda, '+', process(regexp.substring(i + 1)));
        // Exit the operation.
        // I can put a break here, but I'm too lazy to check if nothing breaks.
        i = regexp.length;
      } else {
        var newNda = NonDeterministicAutomaton(
            regexp: char,
            startState: _generateNewState(),
            endState: _generateNewState());
        newNda.startState.addTransition(char, newNda.endState);
        if (nda.regexp == '') {
          nda = newNda;
        } else {
          nda = doOperation(nda, null, newNda);
        }
      }
    }
    return nda;
  }

  NonDeterministicAutomaton doOperation(
      NonDeterministicAutomaton leftNda, String operation,
      [NonDeterministicAutomaton rightNda]) {
    switch (operation) {
      case '*':
        var nda = NonDeterministicAutomaton(
            regexp: '(${leftNda.regexp})*',
            startState: _generateNewState(),
            endState: _generateNewState());
        nda.startState.addTransition(State.epsilon, leftNda.startState);
        nda.startState.addTransition(State.epsilon, nda.endState);
        leftNda.endState.addTransition(State.epsilon, nda.endState);
        leftNda.endState.addTransition(State.epsilon, leftNda.startState);
        return nda;
      case '+':
        var nda = NonDeterministicAutomaton(
            regexp: '(${leftNda.regexp}+${rightNda.regexp})');
        nda.startState.addTransition(State.epsilon, leftNda.startState);
        nda.startState.addTransition(State.epsilon, rightNda.startState);
        leftNda.endState.addTransition(State.epsilon, nda.endState);
        rightNda.endState.addTransition(State.epsilon, nda.endState);
        return nda;
      default:
        for (var transition in rightNda.startState.getTransitions()) {
          if (transition.value.contains(rightNda.startState)) {
            leftNda.endState.addTransition(transition.key, leftNda.endState);
          } else {
            for (var link in transition.value) {
              leftNda.endState.addTransition(transition.key, link);
            }
          }
        }
        rightNda.startState = leftNda.endState;
        leftNda.endState = rightNda.endState;
        leftNda.regexp = leftNda.regexp + rightNda.regexp;
        return leftNda;
    }
  }

  void changeEndStateSetup(State start, State oldEnd, State newEnd) {
    var visited = Set<State>();
    changeEndState(visited, start, oldEnd, newEnd);
  }

  void changeEndState(
      Set<State> visited, State start, State oldEnd, State newEnd) {
    if (visited.contains(start) || start == newEnd) {
      return;
    }
    visited.add(start);
    for (var entry in start.getTransitions()) {
      for (var state in entry.value) {
        if (state == oldEnd) {
          state = newEnd;
        } else {
          changeEndState(visited, state, oldEnd, newEnd);
        }
      }
    }
  }

  State _generateNewState() {
    State newState = State('q$stateNum');
    stateNum++;
    return newState;
  }

  /// Getters and setters
  String get regexp => _regexp;

  set regexp(String value) {
    _regexp = value;
  }

  State get endState => _endState;

  set endState(State value) {
    _endState = value;
  }

  State get startState => _startState;

  set startState(State value) {
    _startState = value;
  }
}
