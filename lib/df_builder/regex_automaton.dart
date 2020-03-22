import 'dart:collection';
import 'package:RegexpFolderFinder/df_builder/state.dart';
import 'package:RegexpFolderFinder/df_builder/non_deterministic_automaton.dart';
import 'package:RegexpFolderFinder/utils.dart';

// Class that creates a graph to evaluate simple regular expressions.
class RegexAutomaton {
  NonDeterministicAutomaton automaton;

  RegexAutomaton(String regexp) {
    this.automaton = NonDeterministicAutomaton(regexp: regexp).generateGraph();
  }

  bool isValid(String expression) {
    if (testExpression("")) {
      return regexpInString(expression, this.automaton.startState);
    }
    for (int i = 0; i < expression.length; i++) {
      var valid =
          regexpInString(expression.substring(i), this.automaton.startState);
      if (valid) {
        return true;
      }
    }
    return false;
  }

  bool regexpInString(String expression, State startState) {
    if (startState.endState) {
      return true;
    }
    var currentStates = Queue<State>();
    currentStates.add(startState);
    var epsilonStates = getEpsilonStates(startState);
    for (var state in epsilonStates) {
      if (state.endState) {
//        if (startState != this.automaton.startState) {
//          return true;
//        }
        return true;
      }
      if (!currentStates.contains(state)) {
        currentStates.add(state);
      }
    }
    int currentIndex = 0;
    while (currentStates.isNotEmpty && currentIndex < expression.length) {
      var currentState = currentStates.removeFirst();
      var currentChar = getChar(expression, currentIndex);
      for (var state in currentState.getTransitions()) {
        if (state.key == currentChar) {
          for (var innerState in state.value) {
            if (regexpInString(expression.substring(currentIndex + 1), innerState)) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  /// The "you don't have time to check what is happening function".
  ///
  /// This functions sucks really bad. I don't think I can even comprehend the
  /// elevated complexity it has, surely exponential, please do not
  /// replicate this abomination. Do not watch its functionality if you don't
  /// want CLINICAL depression.
  bool testExpression(String expression) {
    var currentStates = getLastStates(expression, automaton.startState);
    var results = List<State>();
    if (currentStates.isNotEmpty) {
      while (currentStates.isNotEmpty) {
        var state = currentStates.removeFirst();
        results.addAll(getEpsilonStates(state));
      }
    }
    for (var state in results) {
      if (state.endState) {
        return true;
      }
    }
    return false;
  }

  List<State> getEpsilonStates(State state) {
    var currentStates = List<State>();
    for (var entry in state.getTransitions()) {
      if (entry.key == State.epsilon) {
        // Add all the recursive states given of the current character.
        for (var cstate in entry.value) {
          if (!currentStates.contains(cstate)) {
            currentStates.add(cstate);
          }
          for (var finalState in getEpsilonStates(cstate)) {
            if (!currentStates.contains(finalState)) {
              currentStates.add(finalState);
            }
          }
        }
      }
    }
    return currentStates;
  }

  Queue<State> getLastStates(String expression, State startState) {
    var currentStates = Queue<State>();
    currentStates.add(startState);
    currentStates.addAll(getEpsilonStates(startState));
    int currentIndex = 0;
    while (currentStates.isNotEmpty && currentIndex < expression.length) {
      var lastStates = currentStates.toList();
      currentStates.clear();
      for (var previous in lastStates) {
        State currentState = previous;
        var char = getChar(expression, currentIndex);
        for (var entry in currentState.getTransitions()) {
          if (entry.key == State.epsilon) {
            // Add all the recursive states given of the current character.
            for (var state in entry.value) {
              currentStates.addAll(getLastStates(char, state));
            }
          }
          if (entry.key == char) {
            for (var state in entry.value) {
              if (!currentStates.contains(state)) {
                currentStates.add(state);
                for (var thing in currentState.getTransitions()) {
                  if (thing.key == State.epsilon) {
                    for (var s in thing.value) {
                      getLastStates(char, s);
                    }
                  }
                }
              }
            }
          }
        }
      }
      currentIndex++;
    }
    return currentStates;
  }
}
