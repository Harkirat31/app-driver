import 'package:drivers/helper/dialog_box.dart';
import 'package:drivers/helper/loading/loading_screen.dart';
import 'package:drivers/model/driver_company.dart';
import 'package:drivers/model/path.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PathsList extends StatelessWidget {
  final DriverCompany? driverCompany;

  const PathsList({super.key, this.driverCompany});

  

  @override
  Widget build(BuildContext context) {
    List<Path>? paths = driverCompany?.paths;
    if (paths == null) {
      return const Text("No Order is Assigned on this date");
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Set the border radius
                border: Border.all(
                  color: Colors.grey, // Set the border color
                  width: 2.0, // Set the border width
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "ASSIGNED ROUTE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/mapView",
                                arguments: {
                                  "company": driverCompany,
                                  "path": paths[index]
                                });
                          },
                          child: const Text(
                            "MAP VIEW",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,),
                          ),
                        ),
                        Text(
                            "Date : ${paths[index].dateOfPath!.toString().substring(0, 11)}")
                      ],
                    ),
                  ),
                  paths[index].isAcceptedByDriver ==null? 
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.green
                            ),
                           
                            child: const Text(
                              "Accept",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white ),
                            ),
                          ),
                          onTap: () async {
                             bool result = await  showConfirmationDialog(context);
                            if(result){
                             
                              ApiService().markAcceptedOrRejected(paths[index].pathId!, true).then((result){
                                  paths[index].isAcceptedByDriver = true;
                              context.read<DriverCompanyProvider>().updateData();
                              }).onError((error, stackTrace) {
                                print("Error Calling the API for upadating Accpetance and rejection");
                              
                                });
                            
                            }
                          },
                        ),
                        const SizedBox(width: 10,),
                       GestureDetector(
                         child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.red 
                            ),
                           
                            child: const Text(
                              "Reject",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white ),
                            ),
                          ),
                          onTap: () async {
                            bool result = await  showConfirmationDialog(context);
                            if(result){
                              ApiService().markAcceptedOrRejected(paths[index].pathId!, false).then((result){
                                  paths[index].isAcceptedByDriver = false;
                              context.read<DriverCompanyProvider>().updateData();
                              }).onError((error, stackTrace) {
                                print("Error Calling the API for upadating Accpetance and rejection");
                                });
                            }
                          },
                       ),
                        
                        
                      ],
                    ),
                  ):Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                       Text(paths[index].isAcceptedByDriver!?"Accepted by you":"Rejected by you",
                                style: const TextStyle(fontWeight: FontWeight.bold ),
                              ),
                        ],
                      ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                  
                  const SizedBox(height: 5,),
                  Column(
                    children:
                        List.generate(paths[index].path!.length, (indexOrder) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6,horizontal:0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/orderInfo",
                                arguments: paths[index].path![indexOrder]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.location_pin),
                                  const SizedBox(height: 6,),
                                  // if index is the last element , then avoid grey line 
                                  indexOrder!=paths[index].path!.length-1?
                                  Container(
                                    color: Colors.grey,
                                    width: 2,
                                    height: 80,         
                                  ):const SizedBox()
                                ],
                              ),
                              const SizedBox(width: 20,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order ${indexOrder + 1} ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline),
                                        ),
                                        
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Address : ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          paths[index].path![indexOrder].address,
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Details : ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          paths[index]
                                                  .path![indexOrder]
                                                  .itemsDetail ??
                                              "No Details",
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Instructions : ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          paths[index]
                                                  .path![indexOrder]
                                                  .specialInstructions ??
                                              "No instructions",
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                         const Text(
                                          "Status : ",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        paths[index]
                                                    .path![indexOrder]
                                                    .currentStatus ==
                                                "Delivered"
                                            ? const Text(
                                                "Delivered",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            : const Text(
                                                "Pending",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold),
                                              )
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              "/orderInfo",
                                              arguments:
                                                  paths[index].path![indexOrder]);
                                        },
                                        child: const Text(
                                          "More Info",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              color: Colors.blue),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ]),
              ),
            );
          },
          itemCount: paths.length,
        ),
      );
    }
  }
}

String getDateFormat(DateTime date) {
  return date.toIso8601String();
}

// Widget getPathData(List<OrderModel.Order> orders) {

// }
