import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/orders_controller.dart';
import 'package:qurban_seller/views/messages_screen/chat_screen.dart';
import 'package:qurban_seller/views/orders_screen/components/order_place.dart';
import 'package:qurban_seller/views/orders_screen/components/order_status.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController cancellationReasonController =
      TextEditingController();

  void cancelOrder() async {
    if (widget.data['order_placed'] == false) {
      // Order sudah dibatalkan sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maaf bookingan sudah dibatalkan sebelumnya"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // 1. Mengubah `order_placed` menjadi `false`.

    // 2. Mengembalikan stock produk seperti semula.
    // Jika Anda memiliki field 'stock' di setiap produk di collection produk, Anda bisa melakukan perbaruan sebagai berikut:
    for (var order in widget.data['orders']) {
      var productId = order['product_id'];
      var quantityOrdered = order['qty']; // Tidak perlu konversi ke int

      var productRef = firestore.collection(productsCollection).doc(productId);

      // Mengambil data produk saat ini
      var productData = await productRef.get();

      var currentStock;
      // Check jika p_quantity berupa string atau int
      if (productData['p_quantity'] is String) {
        currentStock = int.tryParse(productData['p_quantity']) ?? 0;
      } else {
        currentStock = productData['p_quantity'];
      }

      // Update stock produk
      await productRef.update({
        'p_quantity': (currentStock + quantityOrdered)
            .toString() // Ubah ke string jika Anda ingin menyimpannya sebagai string
      });
    }
  }

  void cancelOrderConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Apakah Anda yakin ingin membatalkan bookingan ini?"),
              const SizedBox(height: 20.0),
              TextField(
                controller: cancellationReasonController,
                decoration: const InputDecoration(
                  labelText: "Alasan Pembatalan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text("Ya"),
              onPressed: () async {
                if (cancellationReasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Harap isi alasan pembatalan agar bookingan dapat dibatalkan!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                // Simpan alasan pembatalan ke Firebase
                await firestore
                    .collection(orderCollection)
                    .doc(widget.data.id)
                    .update({
                  'cancellation_reason': cancellationReasonController.text,
                  'order_placed': false
                });

                // Tutup dialog
                Navigator.of(context).pop();

                if (widget.data['order_placed'] == false) {
                  // Order sudah dibatalkan sebelumnya
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Maaf bookingan sudah dibatalkan sebelumnya"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                } else {
                  cancelOrder(); // Panggil fungsi cancelOrder
                }
              },
            ),
          ],
        );
      },
    );
  }

  void finishOrder() async {
    // Updating `order_delivered` to true
    await firestore.collection(orderCollection).doc(widget.data.id).update({
      'order_delivered': true,
    });
  }

  var controller = Get.put(OrdersController());
  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    //controller.confirmed.value = widget.data['order_confirmed'];
    controller.confirmed.value = widget.data['order_delivered'];
    controller.confirmed.value = widget.data['order_placed'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: darkGrey,
          ),
        ),
        title: boldText(text: "Order details", color: fontGrey, size: 16.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //visible: controller.confirmed.value,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                      text: "Order status : ", color: fontGrey, size: 16.0),
                  orderStatus(
                      color: redColor,
                      icon: Icons.done,
                      title: "Booking",
                      showDone: widget.data['order_placed']),
                  ElevatedButton(
                    onPressed: widget.data['order_placed']
                        ? cancelOrderConfirmation // Ubah dari cancelOrder menjadi cancelOrderConfirmation
                        : null,
                    child: const Text("Batalkan Booking"),
                  ),
                  orderStatus(
                      color: Colors.purple,
                      icon: Icons.done_all_rounded,
                      title: "Done",
                      showDone: widget.data['order_delivered']),
                  ElevatedButton(
                    onPressed: (widget.data['order_placed'] &&
                            !widget.data['order_delivered'])
                        ? () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmation"),
                                    content: const Text(
                                        "Apakah Anda yakin ingin menyelesaikan bookingan ini?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Tidak"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Ya"),
                                        onPressed: () async {
                                          finishOrder(); // Call the finishOrder function
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        : null, // Jika order_placed adalah false atau order_delivered adalah true, maka tombol menjadi tidak aktif
                    child: const Text("Selesaikan Bookingan"),
                  ),
                ],
              )
                  .box
                  .padding(const EdgeInsets.all(8.0))
                  .outerShadowMd
                  .white
                  .border(color: lightGrey)
                  .roundedSM
                  .make(),

              10.heightBox,

              //order details screen
              Column(
                children: [
                  orderPlaceDetails(
                    d1: "${widget.data['order_code']}",
                    //d2: DateTime.now(),
                    d2: intl.DateFormat()
                        .add_yMd()
                        .format((widget.data['order_date'].toDate())),
                    title1: "Order Code",
                    title2: "Order Date",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //"Shipping Booked".text.fontFamily(semibold).make(),
                            boldText(
                                text: "Shipping Address", color: purpleColor),
                            "${widget.data['order_by_name']}".text.make(),
                            "${widget.data['order_by_email']}".text.make(),
                            "${widget.data['order_by_nohp']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(
                                  text: "Total Amount", color: purpleColor),
                              boldText(
                                  text: "Rp. ${widget.data['total_amount']}",
                                  color: red,
                                  size: 16.0)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
                  .box
                  .padding(const EdgeInsets.all(8.0))
                  .outerShadowMd
                  .white
                  .border(color: lightGrey)
                  .roundedSM
                  .make(),
              const Divider(),
              10.heightBox,
              if (widget.data['order_placed'] == false)
                "Bookingan sudah dibatalkan, alasan Pembatalan: ${widget.data['cancellation_reason']}"
                    .text
                    .make(),
              10.heightBox,
              boldText(text: "Ordered Product", color: fontGrey, size: 16.0),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  controller.orders.length,
                  ((index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                            title1: "${controller.orders[index]['title']}",
                            title2:
                                "Rp.${controller.orders[index]['tprice'].toString().numCurrency}",
                            d1: "${controller.orders[index]['qty']}x",
                            d2: ""),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 201, 32),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Get.to(
                                () => const ChatScreen(),
                                arguments: [
                                  widget.data['order_by'],
                                  widget.data['order_by_name'],
                                  widget.data['orders'][index]['vendor_id'],
                                ],
                              );
                            },
                            child: const Text("Hubungi Pembeli"),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              )
                  .box
                  .padding(const EdgeInsets.all(8.0))
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
