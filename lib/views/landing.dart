import 'package:drivers/components/paths_list.dart';
import 'package:drivers/model/driver_company.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivers/model/path.dart' as PathModel;

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late List<DriverCompany> driverCompanies;
  int? selectedCompanyIndex;

  @override
  void didChangeDependencies() {
    driverCompanies = context.watch<DriverCompanyProvider>().driverCompanies;
    // selectedCompanyId =
    //     driverCompanies.isNotEmpty ? driverCompanies[0].companyId : null;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DropdownButton getCompaniesDropdown() {
      return DropdownButton(
        isExpanded: true,
        hint: const Text('Select Company'),
        items:
            driverCompanies.asMap().entries.map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem(
            value: item.key,
            child: Text(item.value.companyName!),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCompanyIndex = value!;
          });
        },
        value: selectedCompanyIndex,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          driverCompanies.isNotEmpty
              ? getCompaniesDropdown()
              : const Text("Nothing Assigned"),
          selectedCompanyIndex != null
              ? PathsList(
                  paths: driverCompanies[selectedCompanyIndex!].paths,
                )
              : const Text("Select Company")
        ]),
      ),
    );
  }
}
