import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GlobalIcons {
  static const String FONT_FAMILY = 'wxcIconFont';

  static const String DEFAULT_USER_ICON = 'images/logo.png';
  static const String DEFAULT_IMAGE = 'static/images/default_img.png';

  static const IconData HOME = const IconData(0xe624, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData MORE = const IconData(0xe674, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData SEARCH = const IconData(0xe61c, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData MAIN_DT = const IconData(0xe684, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData MAIN_QS = const IconData(0xe818, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData MAIN_MY = const IconData(0xe6d0, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData MAIN_SEARCH = const IconData(0xe61c, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData LOGIN_USER = const IconData(0xe666, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData LOGIN_PW = const IconData(0xe60e, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData REPOS_ITEM_USER = const IconData(0xe63e, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_STAR = const IconData(0xe643, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_FORK = const IconData(0xe67e, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_ISSUE = const IconData(0xe661, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData REPOS_ITEM_STARED = const IconData(0xe698, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_WATCH = const IconData(0xe681, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_WATCHED = const IconData(0xe629, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_DIR = Icons.folder;
  static const IconData REPOS_ITEM_FILE = const IconData(0xea77, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData REPOS_ITEM_NEXT = const IconData(0xe610, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData USER_ITEM_COMPANY = const IconData(0xe63e, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData USER_ITEM_LOCATION = const IconData(0xe7e6, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData USER_ITEM_LINK = const IconData(0xe670, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData USER_NOTIFY = const IconData(0xe600, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData ISSUE_ITEM_ISSUE = const IconData(0xe661, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData ISSUE_ITEM_COMMENT = const IconData(0xe6ba, fontFamily: GlobalIcons.FONT_FAMILY);
  static const IconData ISSUE_ITEM_ADD = const IconData(0xe662, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData ISSUE_EDIT_H1 = Icons.filter_1;
  static const IconData ISSUE_EDIT_H2 = Icons.filter_2;
  static const IconData ISSUE_EDIT_H3 = Icons.filter_3;
  static const IconData ISSUE_EDIT_BOLD = Icons.format_bold;
  static const IconData ISSUE_EDIT_ITALIC = Icons.format_italic;
  static const IconData ISSUE_EDIT_QUOTE = Icons.format_quote;
  static const IconData ISSUE_EDIT_CODE = Icons.format_shapes;
  static const IconData ISSUE_EDIT_LINK = Icons.insert_link;

  static const IconData NOTIFY_ALL_READ = const IconData(0xe62f, fontFamily: GlobalIcons.FONT_FAMILY);

  static const IconData PUSH_ITEM_EDIT = Icons.mode_edit;
  static const IconData PUSH_ITEM_ADD = Icons.add_box;
  static const IconData PUSH_ITEM_MIN = Icons.indeterminate_check_box;


  static const Icon BOTTOM_DYNAMIC_ITEM = Icon(Icons.home);
  static const Icon BOTTOM_USER_ITEM = Icon(Icons.person);
  static const IconData DYNAMIC_PUBLISH = Icons.add;

  static const IconData OAUTH_QQ = FontAwesomeIcons.qq;
  static const IconData ITEM_COMMENT = FontAwesomeIcons.commentAlt;
  static const IconData ITEM_PRAISE = FontAwesomeIcons.thumbsUp;
  static const IconData ITEM_BROWSE = FontAwesomeIcons.eye;

}
