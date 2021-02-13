import 'package:flutter/material.dart';
import 'package:shipbay/pages/auth/signin.dart';
import 'package:shipbay/pages/auth/signup.dart';
import 'package:shipbay/pages/auth/welcome.dart';
import 'package:shipbay/pages/home.dart';
import 'package:shipbay/pages/loading.dart';
import 'package:shipbay/pages/order/additional_details.dart';
import 'package:shipbay/pages/order/carriers.dart';
import 'package:shipbay/pages/order/completed.dart';
import 'package:shipbay/pages/order/confirmation.dart';
import 'package:shipbay/pages/order/delivery.dart';
import 'package:shipbay/pages/order/delivery_services.dart';
import 'package:shipbay/pages/order/items.dart';
import 'package:shipbay/pages/order/order.dart';
import 'package:shipbay/pages/order/payment_details.dart';
import 'package:shipbay/pages/order/pickup.dart';
import 'package:shipbay/pages/order/pickup_date.dart';
import 'package:shipbay/pages/order/pickup_services.dart';
import 'package:shipbay/pages/public/help.dart';
import 'package:shipbay/pages/public/how_works.dart';
import 'package:shipbay/pages/public/privacy.dart';
import 'package:shipbay/pages/public/terms.dart';
import 'package:shipbay/pages/shipper/acount.dart';
import 'package:shipbay/pages/shipper/card_details.dart';
import 'package:shipbay/pages/shipper/order_details.dart';
import 'package:shipbay/pages/shipper/orders.dart';
import 'package:shipbay/pages/shipper/profile.dart';
import 'package:shipbay/pages/tracking/tracking.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => Loading(),
        '/home': (_) => Home(),
        '/pickup': (_) => Pickup(),
        '/order': (_) => Order(),
        '/pickup-services': (_) => PickupServices(),
        '/pickup-date': (_) => PickupDate(),
        '/delivery': (_) => Delivery(),
        '/delivery-services': (_) => DeliveryServices(),
        '/items': (_) => Items(),
        '/additional-details': (_) => AdditionalDetails(),
        '/carriers': (_) => Carriers(),
        '/payment-details': (_) => PaymentDetails(),
        '/confirm': (_) => Confirmation(),
        '/completed': (_) => Completed(),
        '/welcome': (_) => Welcome(),
        '/signin': (_) => Signin(),
        '/signup': (_) => Signup(),
        '/track': (_) => Tracking(),
        '/acount': (_) => Acount(),
        '/profile': (_) => Profile(),
        '/orders': (_) => Orders(),
        '/order-details': (_) => OrderDetails(),
        '/card': (_) => CardDetails(),
        '/help': (_) => Help(),
        '/how-works': (_) => HowWorks(),
        '/terms': (_) => Terms(),
        '/privacy': (_) => Privacy()
      },
    ));
