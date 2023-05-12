import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/payment_model.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Provider/firestrore_provider.dart';
import 'package:ipark/Screens/PaymentPage/payment_page_view.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PayView extends StatefulWidget {
  const PayView({Key? key}) : super(key: key);

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  late CustomerModel customerModel;

  @override
  void initState() {
    customerModel = CustomerModel.fromMap(
        Provider.of<FirestoreProvider>(context, listen: false).data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentListener(),
      child: Consumer<DocumentListener>(
        builder: (context, listener, _) {
          return Scaffold(
            body: Padding(
              padding: IParkPaddings.mainScaffoldPadding,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  nameMailStream(customerModel.name),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Pending payment",
                    style: IParkStyles.font28HeadlineTextStyle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  pendingPayments(),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Previous Visits",
                    style: IParkStyles.font28HeadlineTextStyle,
                  ),
                  const SizedBox(height: 16,),
                  previousPayments(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> pendingPayments() {
    return FutureBuilder(
              future: CloudFirebaseService.getPendingPayments(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("No payments");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> documentsList = snapshot.data!;
                 if(documentsList.isEmpty) {
                   return Text("There are no active payment");
                 } else {
                   return ListView.builder(
                       shrinkWrap: true,
                       itemCount: documentsList.length,
                       physics: NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) {
                         Map<String, dynamic> documentData =
                         documentsList[index];
                         PaymentModel model =
                         PaymentModel.fromMap(documentData);
                         int durationInMinutes;

                         if (model.endDate == null) {
                           durationInMinutes = model.startDate
                               .difference(DateTime.now())
                               .inMinutes
                               .abs();
                         } else {
                           durationInMinutes = model.endDate!
                               .difference(model.startDate)
                               .inMinutes;
                         }

                         return InkWell(
                           child: Container(
                             decoration: BoxDecoration(
                                 border: Border.all(
                                     color: model.endDate == null
                                         ? Colors.green
                                         : Colors.redAccent,
                                     width: 1),
                                 borderRadius: BorderRadius.circular(16)),
                             height: 120,
                             child: Row(
                               children: [
                                 Column(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.start,
                                   children: [
                                     SizedBox(
                                       height: 8,
                                     ),
                                     Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       children: [
                                         SizedBox(
                                           width: 8,
                                         ),
                                         ClipRRect(
                                           borderRadius:
                                           BorderRadius.circular(20),
                                           child: Image.network(
                                             model.carImageUrl,
                                             width: 60,
                                             height: 60,
                                             fit: BoxFit.cover,
                                           ),
                                         ),
                                         SizedBox(
                                           width: 16,
                                         ),
                                         Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             const SizedBox(
                                               height: 8,
                                             ),
                                             Row(
                                               children: [
                                                 SizedBox(
                                                   height: 8,
                                                 ),
                                                 Text(
                                                   "Plate Number: ",
                                                   style: IParkStyles
                                                       .font16PayTextStyle,
                                                 ),
                                                 Text(model.carPlateNumber),
                                               ],
                                             ),
                                             Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.start,
                                               children: [
                                                 SizedBox(
                                                   height: 8,
                                                 ),
                                                 Text(
                                                   "Enterance: ",
                                                   style: IParkStyles
                                                       .font16PayTextStyle,
                                                 ),
                                                 Text(DateFormat("Hm")
                                                     .format(model.startDate)),
                                               ],
                                             ),
                                             Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.start,
                                               children: [
                                                 SizedBox(
                                                   height: 8,
                                                 ),
                                                 Text(
                                                   "Exit: ",
                                                   style: IParkStyles
                                                       .font16PayTextStyle,
                                                 ),
                                                 Text(model.endDate == null
                                                     ? "Still in park"
                                                     : DateFormat("Hm").format(
                                                     model.endDate!)),
                                               ],
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                     const Spacer(),
                                     Row(
                                       children: [
                                         SizedBox(
                                           width: 8,
                                         ),
                                         Text("Total Duration: ",
                                             style: IParkStyles
                                                 .font16PayTextStyle),
                                         Text(durationInMinutes.toString() +
                                             " minutes"),
                                       ],
                                     ),
                                     const SizedBox(
                                       height: 16,
                                     )
                                   ],
                                 ),
                                 const Spacer(),
                                 Icon(
                                   FlutterRemix.bank_card_fill,
                                   size: 50,
                                   color: IParkColors.activeInputBorderColor,
                                 ),
                                 const SizedBox(
                                   width: 16,
                                 ),
                               ],
                             ),
                           ),
                           onTap: () {
                             if (model.endDate == null) {
                               CloudFirebaseService.showCustomSnackBar(
                                   "Your car still in parking place.",
                                   context);
                             } else {
                               Navigator.of(context, rootNavigator: true)
                                   .push(MaterialPageRoute(
                                   builder: (context) => PaymentPageView(
                                     durationInMinutes:
                                     durationInMinutes,
                                     plateNumber: model.carPlateNumber,
                                   )));
                             }
                           },
                         );
                       });
                 }
                } else {
                  return const Text("Network error");
                }
              });
  }

  FutureBuilder<List<Map<String, dynamic>>> previousPayments() {
    return FutureBuilder(
        future: CloudFirebaseService.getPreviousPayments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("No payments");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<Map<String, dynamic>> documentsList = snapshot.data!;

            if(documentsList.isEmpty) {
              return Text("There are no previous data");
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documentsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> documentData =
                    documentsList[index];
                    PaymentModel model =
                    PaymentModel.fromMap(documentData);
                    int durationInMinutes;

                    if (model.endDate == null) {
                      durationInMinutes = model.startDate
                          .difference(DateTime.now())
                          .inMinutes
                          .abs();
                    } else {
                      durationInMinutes = model.endDate!
                          .difference(model.startDate)
                          .inMinutes;
                    }

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: IParkColors.activeInputBorderColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(16)),
                          height: 120,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        child: Image.network(
                                          model.carImageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "Plate Number: ",
                                                style: IParkStyles
                                                    .font16PayTextStyle,
                                              ),
                                              Text(model.carPlateNumber),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "Enterance: ",
                                                style: IParkStyles
                                                    .font16PayTextStyle,
                                              ),
                                              Text(DateFormat("Hm")
                                                  .format(model.startDate)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "Exit: ",
                                                style: IParkStyles
                                                    .font16PayTextStyle,
                                              ),
                                              Text(model.endDate == null
                                                  ? "Still in park"
                                                  : DateFormat("Hm").format(
                                                  model.endDate!)),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text("Total Duration: ",
                                          style: IParkStyles
                                              .font16PayTextStyle),
                                      Text(durationInMinutes.toString() +
                                          " minutes"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                FlutterRemix.check_fill,
                                size: 50,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                      ],
                    );
                  });
            }

          } else {
            return const Text("Network error");
          }
        });
  }

  StreamBuilder<DocumentSnapshot> nameMailStream(String name) {
    return StreamBuilder<DocumentSnapshot>(
        stream: CloudFirebaseService.userDataStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return providerDataWidget(name, customerModel.email);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return providerDataWidget(name, customerModel.email);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return providerDataWidget(name, customerModel.email);
          }
          if (snapshot.hasData) {
            if (snapshot.data.data() != null) {
              customerModel = CustomerModel.fromSnapshot(snapshot);
              return IParkComponents.headlineIconDescriptionWidget(
                customerModel.name,
                customerModel.email,
              );
            } else {
              return providerDataWidget(name, customerModel.email);
            }
          } else {
            return providerDataWidget(name, customerModel.email);
          }
        });
  }

  Row providerDataWidget(String name, String email) {
    return IParkComponents.headlineIconDescriptionWidget(name, email);
  }
}
