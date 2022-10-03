abstract class RegExRoot {
  /// next node
  final RegExRoot? then;

  /// name of group (if any)
  final String? groupName;

  /// regex token
  String get token;

  /// used in [fillWith] to fill value if none passed
  String fillerPlaceHolder;

  /// [RegExp] params enabling/disabling multiline scanning
  final bool multiLine;

  /// [RegExp] params enabling/disabling case sensitive scanner
  final bool caseSensitive;

  /// [RegExp] params enabling/disabling unicode support
  final bool unicode;

  /// [RegExp] params enabling/disabling dot `.` to match anything even line terminators
  final bool dotAll;

  /// regex patter from this node
  String get regexString => then != null ? (token + then!.regexString) : token;

  /// [RegExp] instance of this node
  RegExp get regex => RegExp(
        regexString,
        multiLine: multiLine,
        caseSensitive: caseSensitive,
        unicode: unicode,
        dotAll: dotAll,
      );

  /// returns formatted string with given map
  ///
  /// * source : <String,String>{`<group-name>`:`<value>`}
  ///
  /// * [emptyFiller] if passed and [groupName] was not present in source
  ///   will use this value to fill the place and if not passed will use
  ///   [fillerPlaceHolder]
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

  /// regex node
  /// * then: next node
  /// * groupName: nullable name of group
  /// * fillerPlaceHolder: used in [fillWith] to fill empty spots
  /// * Regex Params:
  /// >- [multiLine] : enabling/disabling multiline scanning
  /// >- [caseSensitive] : enabling/disabling case sensitive scanner
  /// >- [unicode] : enabling/disabling unicode support
  /// >- [dotAll] : enabling/disabling dot `.` to match anything even line terminators
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

  SimpleMatcher({
    required this.token,
    super.then,
    String? fillerPlaceHolder,
    super.multiLine,
    super.caseSensitive,
    super.unicode,
    super.dotAll,
  }) : super(
          fillerPlaceHolder: fillerPlaceHolder ?? token,
        );
}

class SimpleWrapper extends RegExRoot {
  /// wrap a part of token inside it self
  SimpleWrapper({
    required this.inner,
    this.tail = '',
    this.prefix = '',
    super.groupName,
    super.fillerPlaceHolder = '',
    super.then,
    super.multiLine,
    super.caseSensitive,
    super.unicode,
    super.dotAll,
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
  String get token => '$prefix(${inner.regexString})$tail';
  final String prefix;
  final String tail;
  final RegExRoot inner;
}

class GroupMatcher extends RegExRoot {
  @override
  final String token;

  /// matching a group with group name
  /// this allows you to cast formatted strings to map and vice versa
  GroupMatcher({
    required String token,
    required String groupName,
    String? fillerPlaceHolder,
    super.then,
    super.multiLine,
    super.caseSensitive,
    super.unicode,
    super.dotAll,
  })  : token = '(?<$groupName>$token)',
        super(
          groupName: groupName,
          fillerPlaceHolder: fillerPlaceHolder ?? groupName,
        );
}
