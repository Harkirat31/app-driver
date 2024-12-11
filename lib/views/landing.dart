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
  late List<DateTime> futureDates;
  

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
    ApiService().getFuturePathDates(DateTime.now()).then((futureDates) {
      context.read<DriverCompanyProvider>().updateFutureDeliveryDates(futureDates);
      ApiService().getDriverCompanyListWithDate(selectedDate).then((value) {
        context.read<DriverCompanyProvider>().refresh(value);
        LoadingScreen().hide();
      }).onError((error, stackTrace) {
        LoadingScreen().hide();
      });
    }).onError((error, stackTrace) {
      LoadingScreen().hide();
    });
  }

  void changeDate() {
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
    futureDates = context.watch<DriverCompanyProvider>().futureDeliveryDates;
    selectedCompanyIndex = driverCompanies.isNotEmpty ? context.watch<DriverCompanyProvider>().selectedCompanyIndex: null;
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

  bool weatherDatesEqual(DateTime first, DateTime second){
    if(first.toString().substring(0,11)==second.toString().substring(0,11)){
      return true;
    }else{
      return false;
    }
  }

  Widget getUpcomingDeliveries(){
    int futureBoxes = 0;
    if(futureDates.length>2){
      futureBoxes = 3;
    }else if(futureDates.length>1) {
      futureBoxes=2;
    }
    else if(futureDates.isNotEmpty){
      futureBoxes=1;
    }
    
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        for (int i = 0; i < futureBoxes; i++)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    selectedDate = futureDates[i];
                    context.read<DriverCompanyProvider>().updateDate(futureDates[i]);
                    changeDate();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: weatherDatesEqual(selectedDate,futureDates[i])?Colors.blue[900]:Colors.blue,
                  ),
                
                  child: Text(futureDates[i].toString().substring(0, 11).split(' ')[0],style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
         GestureDetector(
                onTap: (){
                  _selectDate(context);
                },
                child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                   decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8)
                   ),
              
                  child: const Text("Custom Date",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
                )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DropdownButton getCompaniesDropdown() {
      return DropdownButton(
        hint: const Text('Select Company'),
        items:
            driverCompanies.asMap().entries.map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem(
            value: item.key,
            child: SizedBox(width: 180,child: Text(item.value.companyName?? "N/A",style: const TextStyle(overflow: TextOverflow.ellipsis),)));
        }).toList(),
        onChanged: (value) {
          setState(() {
          selectedCompanyIndex = value!;
          context.read<DriverCompanyProvider>().updateSelectedCompanyIndex(value);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("UPCOMING DELIVERIES",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                driverCompanies.isNotEmpty
                    ? getCompaniesDropdown()
                    : const Text("Nothing Assigned"),
              ],
            ),
                

            const SizedBox(
                  height: 8.0,
                ),

            getUpcomingDeliveries(),
            const SizedBox(
                  height: 10.0,
                ),
            Row(children: [
              const Text("Selected Date : ",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
              Text(selectedDate.toString().substring(0,11),style: const TextStyle(fontWeight: FontWeight.bold),),
             
            ],),
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
