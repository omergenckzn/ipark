import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/car_data.dart';
import 'package:ipark/Models/car_model.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Provider/firestrore_provider.dart';
import 'package:ipark/Screens/AddCar/add_car_view.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:provider/provider.dart';

class CarsView extends StatefulWidget {
  const CarsView({Key? key}) : super(key: key);

  @override
  State<CarsView> createState() => _CarsViewState();
}

class _CarsViewState extends State<CarsView> {


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
            nameMailStream(customerModel.name,"Cars"),
            const SizedBox(height: 32,),
          StreamBuilder<List<CarData>>(
            stream: CloudFirebaseService.getCarDataFromFirestore(context),
            builder: (BuildContext context, AsyncSnapshot<List<CarData>> snapshot) {
              if (snapshot.hasError) {

                return const Center(child: Text('Network error'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cars found'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final CarModel car = snapshot.data![index].model;
                  return ListTile(

                    title: Text(car.name),
                    subtitle: Text(car.licencePlate),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        CloudFirebaseService.deleteCarFromFirestore(snapshot.data![index].docId,car.imageUrl ,context);
                        setState(() {

                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
            const SizedBox(height: 64,),
            LargeCtaButtonTransparent(textContent: "Add new car", onPressed: (){

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddCarView()));
            }),

          ],
        ),
      ),
    );
  }

  StreamBuilder<DocumentSnapshot> nameMailStream(String name, String description) {
    return StreamBuilder<DocumentSnapshot>(
        stream: CloudFirebaseService.userDataStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return providerDataWidget(name,description);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return providerDataWidget(name,description);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return providerDataWidget(name,description);
          }
          if (snapshot.hasData) {
            if(snapshot.data.data() != null) {
              customerModel = CustomerModel.fromSnapshot(snapshot);
              return IParkComponents.headlineIconDescriptionWidget(
                customerModel.name,
                description,
              );
            }else {
              return providerDataWidget(name,description);
            }
          } else {
            return providerDataWidget(name,description);
          }
        });
  }

  Row providerDataWidget(String name, String description) {
    return IParkComponents.headlineIconDescriptionWidget(name,
        description);
  }
}
