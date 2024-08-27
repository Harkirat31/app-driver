import 'package:drivers/components/paths_list.dart';
import 'package:drivers/helper/loading/loading_screen.dart';
import 'package:drivers/model/driver_company.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/service/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> with WidgetsBindingObserver {
  late List<DriverCompany> driverCompanies;
  int? selectedCompanyIndex;
  late DateTime selectedDate;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((event) {
      refresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void refresh() {
    LoadingScreen().show(context: context, text: "Refreshing..");
    ApiService().getDriverCompanyListWithDate(selectedDate).then((value) {
      context.read<DriverCompanyProvider>().refresh(value);
      LoadingScreen().hide();
    }).onError((error, stackTrace) {
      LoadingScreen().hide();
    });
  }

  void changeDate (){
    LoadingScreen().show(context: context, text: "Refreshing..");
    ApiService().getDriverCompanyListWithDate(selectedDate).then((value) {
      context.read<DriverCompanyProvider>().refresh(value);
      LoadingScreen().hide();
    }).onError((error, stackTrace) {
      LoadingScreen().hide();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  @override
  void didChangeDependencies() {
    driverCompanies = context.watch<DriverCompanyProvider>().driverCompanies;
    selectedDate = context.watch<DriverCompanyProvider>().selectedDate;
    selectedCompanyIndex = driverCompanies.isNotEmpty ? 0 : null;
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
       
      setState(() {
        selectedDate = picked;
        context.read<DriverCompanyProvider>().updateDate(picked);
        changeDate();
      });
    }
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
             Text("${selectedDate.toLocal()}".split(' ')[0]),
            const SizedBox(height: 20.0,),
             ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
            driverCompanies.isNotEmpty
                ? getCompaniesDropdown()
                : const Text("Nothing Assigned"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => refresh(),
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
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
