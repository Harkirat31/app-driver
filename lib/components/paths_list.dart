import 'package:drivers/model/driver_company.dart';
import 'package:drivers/model/path.dart';
import 'package:flutter/material.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Assigned Route",
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
                          "Show in Map",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(
                          "Date : ${paths[index].dateOfPath!.toString().substring(0, 11)}")
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                  Column(
                    children:
                        List.generate(paths[index].path!.length, (indexOrder) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/orderInfo",
                                arguments: paths[index].path![indexOrder]);
                          },
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
