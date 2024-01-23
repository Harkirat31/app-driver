import 'package:drivers/model/driver_company.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    List<DriverCompany> driverCompanies =
        context.watch<DriverCompanyProvider>().driverCompanies;

    print(driverCompanies[0].companyName);

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Column(children: [
        GestureDetector(
            onTap: () {
              driverCompanies[0].companyName = "Harry";
              context.read<DriverCompanyProvider>().updateData();
            },
            child: const Text("data")),
      ]),
    );
  }
}
