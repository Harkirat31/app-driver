import 'package:drivers/model/path.dart';
import 'package:drivers/model/order.dart' as OrderModel;
import 'package:flutter/material.dart';

class PathsList extends StatelessWidget {
  final List<Path>? paths;

  const PathsList({super.key, this.paths});

  @override
  Widget build(BuildContext context) {
    if (paths == null) {
      return const Text("No Order is Assigned");
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
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
                      "Suggested Route",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "Date : ${paths![index].dateOfPath!.toString().substring(0, 11)}")
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: paths![index].path!.length,
                    itemBuilder: (context, indexOrder) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(
                              "Order ${indexOrder + 1}: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              paths![index].path![indexOrder].address,
                              style: const TextStyle(),
                            )
                          ],
                        ),
                      );
                    })
              ]),
            ),
          );
        },
        itemCount: paths!.length,
      );
    }
  }
}

String getDateFormat(DateTime date) {
  return date.toIso8601String();
}

// Widget getPathData(List<OrderModel.Order> orders) {

// }
