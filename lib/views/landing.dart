import 'package:drivers/components/paths_list.dart';
import 'package:drivers/model/driver_company.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    selectedCompanyIndex = driverCompanies.isNotEmpty ? 0 : null;
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
            child: Text(item.value.companyName ?? "N/A"),
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
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            driverCompanies.isNotEmpty
                ? getCompaniesDropdown()
                : const Text("Nothing Assigned"),
            selectedCompanyIndex != null
                ? PathsList(
                    driverCompany: driverCompanies[selectedCompanyIndex!],
                  )
                : const Text("Select Company")
          ]),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                SharedPreferences.getInstance().then((value) {
                  value.remove("token");
                  context.read<DriverCompanyProvider>().logout();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/signIn", (route) => false);
                }).onError((error, stackTrace) {
                  //show error
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
