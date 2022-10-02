import 'package:string_formatter_kit/src/core/regex_extension/regex_part.dart';
import 'package:string_formatter_kit/src/core/string_analyzer.dart';

void main() {
  // final analyzer = StringAnalyzer();

  // final result = analyzer.findKeysInside(':year-:month-:day').toList();

  // print(result);

  final pattern = GroupMatcher(
    groupName: 'year',
    fillerPlaceHolder: '1970',
    token: r'\d{4}',
    then: SimpleMatcher(
      token: '-',
      then: GroupMatcher(
        groupName: 'month',
        fillerPlaceHolder: '00',
        token: r'\d{1,2}',
        then: SimpleMatcher(
          token: '-',
          then: GroupMatcher(
            groupName: 'day',
            fillerPlaceHolder: '00',
            token: r'\d{1,2}',
            then: SimpleMatcher(
              token: ' ',
              then: GroupMatcher(
                groupName: 'hour',
                fillerPlaceHolder: '00',
                token: r'\d{1,2}',
                then: SimpleMatcher(
                  token: ':',
                  then: GroupMatcher(
                    groupName: 'minute',
                    token: r'\d{1,2}',
                    // fillerPlaceHolder: '00',
                    then: SimpleWrapper(
                      fillerPlaceHolder: '00',
                      tail: '{0,1}',
                      inner: SimpleMatcher(
                        token: ':',
                        then: GroupMatcher(
                          groupName: 'seconds',
                          token: r'(\d{1,2})',
                          fillerPlaceHolder: '00',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  final analyzer = StringAnalyzer(tokenRoot: pattern);
  print(pattern.regexString);

  // final regex = RegExp(pattern.buildPattern);
  final res = pattern.fillWith(
    {
      'year': '1999',
      'month': '12',
      'day': '26',
      'hour': '21',
      'minute': '51',
      // 'seconds': '51',
    },
  );
  print(res);
  print(analyzer.readAllToMap('''
1999-12-26 51:511999-12-26 51:52 1999-12-26 51:53''').toList());
}
