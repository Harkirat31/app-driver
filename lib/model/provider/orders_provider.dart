import 'dart:collection';

import 'package:drivers/model/order.dart';
import 'package:flutter/foundation.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  UnmodifiableListView<Order> get orders => UnmodifiableListView(_orders);

  void addOrders(List<Order> orders) {
    _orders.addAll(orders);
    notifyListeners();
  }
}
