abstract class RegExRoot {
  final RegExRoot? then;
  final String? groupName;
  String get token;
  String fillerPlaceHolder;
  final bool multiLine;
  final bool caseSensitive;
  final bool unicode;
  final bool dotAll;
  String get regexString => then != null ? (token + then!.regexString) : token;
  RegExp get regex => RegExp(
        regexString,
        multiLine: multiLine,
        caseSensitive: caseSensitive,
        unicode: unicode,
        dotAll: dotAll,
      );
  String fillWith(
    Map<String, String> source, {
    String? emptyFiller,
  }) {
    final value = //
        source[groupName ?? token] ?? emptyFiller ?? fillerPlaceHolder;
    return then != null //
        ? (value + then!.fillWith(source, emptyFiller: emptyFiller))
        : value;
  }

  RegExRoot({
    this.then,
    this.groupName,
    required this.fillerPlaceHolder,
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
  });
}

class SimpleMatcher extends RegExRoot {
  @override
  final String token;

  SimpleMatcher({required this.token, super.then, String? fillerPlaceHolder})
      : super(
          fillerPlaceHolder: fillerPlaceHolder ?? token,
        );
}

class SimpleWrapper extends RegExRoot {
  SimpleWrapper({
    required this.inner,
    this.tail = '',
    super.groupName,
    super.fillerPlaceHolder = '',
    super.then,
  });
  @override
  String fillWith(
    Map<String, String> source, {
    String? emptyFiller,
  }) {
    final value = inner.fillWith(source);
    return then != null //
        ? (value + then!.fillWith(source, emptyFiller: emptyFiller))
        : value;
  }

  @override
  String get token => '(${inner.regexString})$tail';
  final String tail;
  final RegExRoot inner;
}

class GroupMatcher extends RegExRoot {
  @override
  final String token;
  GroupMatcher({
    required String token,
    required String groupName,
    String? fillerPlaceHolder,
    super.then,
  })  : token = '(?<$groupName>$token)',
        super(
          groupName: groupName,
          fillerPlaceHolder: fillerPlaceHolder ?? groupName,
        );
}
