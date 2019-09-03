/// Node of the Automaton.
///
/// By default is not an end state.
class State {
  /// Transitions defined by the symbol, in this case, a character.
  Map<String, State> _transitions;

  /// Defines if this instance of the [State] is an end state.
  bool endState;

  State({this.endState = false}) {
    _transitions = Map<String, State>();
  }

  /// Adds a new entry to [_transitions] of the state.
  ///
  /// Throws an [ArgumentError] if the symbol is not a single character.
  void addTransition(String symbol, State nextState) {
    if (symbol.length > 1) {
      throw ArgumentError("The symbol must be only one character");
    }
    _transitions[symbol] = nextState;
  }

  /// Returns the State of the transition given a symbol.
  ///
  /// Throws an [ArgumentError] if the symbol given does not exists.
  State getStateFromSymbol(String symbol) {
    if (_transitions[symbol] == null) {
      throw ArgumentError("The transition to that symbol does not exist");
    }
    return _transitions[symbol];
  }
}
