import 'package:flutter/material.dart';
import 'package:shipbay/pages/home.dart';
import 'package:shipbay/pages/loading.dart';
import 'package:shipbay/pages/order/additional_details.dart';
import 'package:shipbay/pages/order/carriers.dart';
import 'package:shipbay/pages/order/delivery.dart';
import 'package:shipbay/pages/order/delivery_services.dart';
import 'package:shipbay/pages/order/items.dart';
import 'package:shipbay/pages/order/order.dart';
import 'package:shipbay/pages/order/payment_details.dart';
import 'package:shipbay/pages/order/pickup.dart';
import 'package:shipbay/pages/order/pickup_date.dart';
import 'package:shipbay/pages/order/pickup_services.dart';
import 'package:shipbay/pages/shipper/shipper.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (_) => Loading(),
        '/home': (_) => Home(),
        '/order': (_) => Order(),
        '/pickup': (_) => Pickup(),
        '/pickup-services': (_) => PickupServices(),
        '/pickup-date': (_) => PickupDate(),
        '/delivery': (_) => Delivery(),
        '/delivery-services': (_) => DeliveryServices(),
        '/items': (_) => Items(),
        '/additional-details': (_) => AdditionalDetails(),
        '/carriers': (_) => Carriers(),
        '/payment-details': (_) => PaymentDetails(),
        '/shipper': (_) => Shipper()
      },
    ));
