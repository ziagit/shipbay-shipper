import 'package:flutter/material.dart';
import 'package:shipbay/moving/pages/customer/customer_acount.dart';
import 'package:shipbay/moving/pages/customer/customer_card_details.dart';
import 'package:shipbay/moving/pages/customer/customer_order_details.dart';
import 'package:shipbay/moving/pages/customer/customer_orders.dart';
import 'package:shipbay/moving/pages/customer/customer_profile.dart';
//moving
import 'package:shipbay/moving/pages/order/moving.dart';
import 'package:shipbay/moving/pages/order/confirm.dart';
import 'package:shipbay/moving/pages/order/from.dart';
import 'package:shipbay/moving/pages/order/from_state.dart';
import 'package:shipbay/moving/pages/order/contacts.dart';
import 'package:shipbay/moving/pages/order/movers.dart';
import 'package:shipbay/moving/pages/order/moving_date.dart';
import 'package:shipbay/moving/pages/order/moving_size.dart';
import 'package:shipbay/moving/pages/order/number_of_movers.dart';
import 'package:shipbay/moving/pages/order/office_size.dart';
import 'package:shipbay/moving/pages/order/payment.dart';
import 'package:shipbay/moving/pages/order/supplies.dart';
import 'package:shipbay/moving/pages/order/to.dart';
import 'package:shipbay/moving/pages/order/to_state.dart';
import 'package:shipbay/moving/pages/order/vehicle_size.dart';
//shared
import 'package:shipbay/shared/auth/signin.dart';
import 'package:shipbay/shared/auth/signup.dart';
import 'package:shipbay/shared/auth/welcome.dart';
//shapping
import 'package:shipbay/shared/public/home.dart';
import 'package:shipbay/shared/public/loading.dart';
import 'package:shipbay/shipping/pages/order/additional_details.dart';
import 'package:shipbay/shipping/pages/order/carriers.dart';
import 'package:shipbay/shipping/pages/order/completed.dart';
import 'package:shipbay/shipping/pages/order/confirmation.dart';
import 'package:shipbay/shipping/pages/order/delivery.dart';
import 'package:shipbay/shipping/pages/order/delivery_services.dart';
import 'package:shipbay/shipping/pages/order/items.dart';
import 'package:shipbay/shipping/pages/order/order.dart';
import 'package:shipbay/shipping/pages/order/payment_details.dart';
import 'package:shipbay/shipping/pages/order/pickup.dart';
import 'package:shipbay/shipping/pages/order/pickup_date.dart';
import 'package:shipbay/shipping/pages/order/pickup_services.dart';
import 'package:shipbay/shared/public/help.dart';
import 'package:shipbay/shared/public/about.dart';
import 'package:shipbay/shared/public/how_works.dart';
import 'package:shipbay/shared/public/privacy.dart';
import 'package:shipbay/shared/public/terms.dart';
import 'package:shipbay/shipping/pages/shipper/acount.dart';
import 'package:shipbay/shipping/pages/shipper/card_details.dart';
import 'package:shipbay/shipping/pages/shipper/order_details.dart';
import 'package:shipbay/shipping/pages/shipper/orders.dart';
import 'package:shipbay/shipping/pages/shipper/profile.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Open Sans'),
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
        '/about': (_) => About(),
        '/acount': (_) => Acount(),
        '/profile': (_) => Profile(),
        '/orders': (_) => Orders(),
        '/order-details': (_) => OrderDetails(),
        '/card': (_) => CardDetails(),

        //shared
        '/help': (_) => Help(),
        '/how-works': (_) => HowWorks(),
        '/terms': (_) => Terms(),
        '/privacy': (_) => Privacy(),
        '/signin': (_) => Signin(),
        '/signup': (_) => Signup(),
        '/welcome': (_) => Welcome(),

//moving routes
        '/moving': (_) => Moving(),
        '/from': (_) => From(),
        '/to': (_) => To(),
        '/from-state': (_) => FromState(),
        '/to-state': (_) => ToState(),
        '/moving-sizes': (_) => MovingSize(),
        '/office-sizes': (_) => OfficeSize(),
        '/vehicle-sizes': (_) => VehicleSize(),
        '/number-of-movers': (_) => NumberOfMovers(),
        '/moving-date': (_) => MovingDate(),
        '/supplies': (_) => Supplies(),
        '/contacts': (_) => Contacts(),
        '/movers': (_) => Movers(),
        '/payment': (_) => Payment(),
        '/confirm-move': (_) => Confirm(),

        '/customer-acount': (_) => CustomerAcount(),
        '/customer-profile': (_) => CustomerProfile(),
        '/customer-orders': (_) => CustomerOrders(),
        '/customer-order-details': (_) => CustomerOrderDetails(),
        '/customer-card-details': (_) => CUstomerCardDetails(),
      },
    ));
