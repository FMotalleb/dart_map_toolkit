/// Simple basic regex tokens
abstract class EzRegEx {
  EzRegEx._();

  /// match start of the text(line)
  static const startOfText = r'^';

  /// match end of the text(line)
  static const endOfText = r'$';

  /// matches one or more
  static const oneOrMore = '+';

  /// matches any amount
  static const zeroOrMore = '*';

  /// matches any thing (digits, spaces, chars, even if you active dotMatchAll it will match line terminator)
  static const anyThing = '.';

  /// any word char [a-z][A-z]
  static const words = r'\w';

  /// match anything but word char [a-z][A-z]
  static const notWords = r'\W';

  /// matches any digit [0-9]
  static const digits = r'\d';

  /// matches anything but digit [0-9]
  static const notDigits = r'\D';

  /// matches space (\t, ` `)
  static const whitespace = r'\s';

  /// matches anything but space (\t, ` `)
  static const notWhitespace = r'\S';

  /// matches only one or zero
  static const oneOrNone = r'?';

  /// [source] value or more
  static String thisMuchOrMore(int source) => '{$source,}';

  /// any of [source] char
  /// [not] if set to true will match anything but [source]
  static String anyOf(
    List<String> source, {
    bool not = false,
  }) =>
      '[${not ? '^' : ''}${source.join()}]';

  /// between [start] and [end] char
  static String betweenChars(String start, String end) => '[$start-$end]';

  /// between [start] and [end] count
  static String betweenCount(int start, int end) => '{$start,$end}';

  /// match one of [source]
  static String or(
    List<String> source,
  ) =>
      group(
        child: source.join('|'),
      );

  /// create a group with [child] token
  /// create named group if [name] was passed
  static String group({
    String? name,
    required String child,
  }) =>
      '(${name != null ? '?<$name>' : ''}$child)';
}
