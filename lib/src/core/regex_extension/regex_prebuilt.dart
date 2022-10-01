abstract class EzRegEx {
  EzRegEx._();
  static const startOfText = r'^';
  static const endOfText = r'$';
  static const oneOrMore = '+';
  static const zeroOrMore = '*';
  static const anyThing = '.';
  static const words = r'\w';
  static const notWords = r'\W';
  static const digits = r'\d';
  static const notDigits = r'\D';
  static const whitespace = r'\s';
  static const notWhitespace = r'\S';
  static const oneOrNone = r'?';
  static String thisMuchOrMore(int source) => '{$source,}';
  static String anyOf(
    List<String> source, {
    bool not = false,
  }) =>
      '[${not ? '^' : ''}${source.join()}]';
  static String betweenChars(String start, String end) => '[$start-$end]';
  static String betweenCount(int start, int end) => '{$start,$end}';

  static String or(
    List<String> source,
  ) =>
      group(
        child: source.join('|'),
      );

  static String group({
    String? name,
    required String child,
  }) =>
      '(${name != null ? '?<$name>' : ''}$child)';
}
