import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/orders_controller.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/orders_screen/order_detail.dart';
import 'package:qurban_seller/views/widgets/appbar_widget.dart';
import 'package:qurban_seller/views/widgets/dashboard_button.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
//import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashboardButton(context,
                          title: products, count: "${data.length}", icon: icProducts),
                     
                    ],
                  ),
                  
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  boldText(text: terjual, color: fontGrey, size: 16.0),
                  20.heightBox,
                  
                ],
              ),
            );
          }
        },
      ),
      /*
      body: */
    );
  }
}
