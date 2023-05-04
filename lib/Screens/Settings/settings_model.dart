import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class SettingsModel {

  String editUserSetting = "Edit";
  String premiumSetting = "Premium";
  String reminderString = "Reminder";
  String deleteAccount = "Delete my account";
  String privacyPolicy = "Privacy policy";
  String logout= "Logout";
  String settingsDescription = "Settings";


  IconData notificationIcon = FlutterRemix.notification_3_line;
  IconData editIcon = FlutterRemix.edit_box_line;
  IconData premiumIcon = FlutterRemix.vip_diamond_line;
  IconData deleteAccountIcon = FlutterRemix.delete_bin_7_line;
  IconData logoutIcon = FlutterRemix.logout_box_line;
  IconData privacyIcon = FlutterRemix.git_repository_private_line;

}