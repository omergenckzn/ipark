import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_constants.dart';


class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          children: [
            Text("LoginPage"),

          ],
        ),
      ),
    );
  }
}
