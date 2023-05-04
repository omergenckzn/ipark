import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Provider/firestrore_provider.dart';
import 'package:ipark/Screens/Settings/settings_model.dart';
import 'package:ipark/Screens/page_router.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:provider/provider.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  SettingsModel model = SettingsModel();
  late CustomerModel customerModel;

  @override
  void initState() {
    customerModel = CustomerModel.fromMap(Provider.of<FirestoreProvider>(context,listen: false).data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: ListView(
          children: [
            const SizedBox(height: 32,),
            nameMailStream(customerModel.name),
            const SizedBox(height: 32,),
            SettingsActionButton(content: model.editUserSetting, iconPath: model.editIcon, onTap: (){}),
            SettingsActionButton(content: model.premiumSetting, iconPath: model.premiumIcon, onTap: (){}),
            SettingsActionButton(content: model.reminderString, iconPath: model.notificationIcon, onTap: (){}),
            SettingsActionButton(content: model.privacyPolicy, iconPath: model.privacyIcon, onTap: (){}),
            SettingsActionButton(content: model.logout, iconPath: model.logoutIcon, onTap: ()  {

              CloudFirebaseService.signOut();
              Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const PageRouter()));
            }),
            SettingsActionButton(content: model.deleteAccount, iconPath: model.deleteAccountIcon, onTap: (){})
          ],
        ),
      ),
    );
  }

  StreamBuilder<DocumentSnapshot> nameMailStream(String name) {
    return StreamBuilder<DocumentSnapshot>(
        stream: CloudFirebaseService.userDataStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return providerDataWidget(name);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return providerDataWidget(name);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return providerDataWidget(name);
          }
          if (snapshot.hasData) {
            if(snapshot.data.data() != null) {
              customerModel = CustomerModel.fromSnapshot(snapshot);
              return IParkComponents.headlineIconDescriptionWidget(
                  customerModel.name,
                  model.settingsDescription,
                  );
            }else {
              return providerDataWidget(name);
            }
          } else {
            return providerDataWidget(name);
          }
        });
  }

  Row providerDataWidget(String babyName) {
    return IParkComponents.headlineIconDescriptionWidget(babyName,
        model.settingsDescription);
  }

}




class SettingsActionButton extends StatelessWidget {
  const SettingsActionButton(
      {Key? key,
        required this.content,
        required this.iconPath,
        required this.onTap})
      : super(key: key);

  final String content;
  final IconData iconPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),
        enableFeedback: false,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: SizedBox(
          height: 70,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    iconPath,
                    color: IParkColors.blackHeadlineColor,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      letterSpacing: IParkConstants.textLetterSpacing,
                      fontSize: 16,
                      fontFamily: IParkConstants.fontFamilyText,
                      fontWeight: FontWeight.w500,
                      color: IParkColors.blackHeadlineColor,
                    ),
                  ),
                  const Spacer(),
                  const Icon(FlutterRemix.arrow_right_s_line)
                ],
              )
            ],
          ),
        ));
  }
}