import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
//import 'package:qurban_seller/controllers/orders_controller.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/orders_screen/order_detail.dart';
import 'package:qurban_seller/views/widgets/appbar_widget.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var controller = Get.put(OrdersController());
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            if (data.isEmpty) {
              // Jika tidak ada produk
              return Center(child: Text("Belum ada pesanan yang masuk"));
            }
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        children: List.generate(
                      data.length,
                      ((index) {
                        var time = data[index]['order_date'].toDate();
                        return Card(
                          elevation: 2, // Tambahkan bayangan
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => OrderDetails(data: data[index]));
                            },
                            tileColor:
                                Colors.white, // Ganti warna latar belakang
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Row(
                              children: [
                                Icon(Icons.calendar_view_day,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                boldText(
                                  text:
                                      "${data[index]['order_code']}", // Ganti dengan status pesanan yang sesuai
                                  color: Color.fromARGB(
                              255, 219, 201, 32), // Ganti warna sesuai status pesanan
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, color: Colors.grey),
                                const SizedBox(width: 8),
                                boldText(
                                  text: intl.DateFormat()
                                      .add_yMd()
                                      .add_Hm()
                                      .format(time),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            
                            trailing: boldText(
                              text:
                                  "Rp. ${data[index]['total_amount'].toString().numCurrency}",
                              color: purpleColor,
                              size: 16.0,
                            ),
                          ),
                        );
                      }),
                    ))));
          }
        }),
      ),
    );
  }
}
