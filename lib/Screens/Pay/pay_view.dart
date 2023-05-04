import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Provider/firestrore_provider.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:provider/provider.dart';
class PayView extends StatefulWidget {
  const PayView({Key? key}) : super(key: key);

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {


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
            return providerDataWidget(name,customerModel.email);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return providerDataWidget(name,customerModel.email);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return providerDataWidget(name,customerModel.email);
          }
          if (snapshot.hasData) {
            if(snapshot.data.data() != null) {
              customerModel = CustomerModel.fromSnapshot(snapshot);
              return IParkComponents.headlineIconDescriptionWidget(
                customerModel.name,
                customerModel.email,
              );
            }else {
              return providerDataWidget(name,customerModel.email);
            }
          } else {
            return providerDataWidget(name,customerModel.email);
          }
        });
  }

  Row providerDataWidget(String name, String email) {
    return IParkComponents.headlineIconDescriptionWidget(name,
        email);
  }
}
