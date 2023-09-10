import 'package:qurban_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore.collection(vendorsCollection).where('id', isEqualTo: uid).get() ;
  }

  static getMessages(uid) {
    return firestore.collection(chatsCollection).where('users',arrayContains: uid).snapshots();
  }

  //get all chat messages
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore.collection(orderCollection).where('vendors', arrayContains: uid).snapshots();
  }

  static getProducts(uid) {
    return firestore.collection(productsCollection).where('vendor_id', isEqualTo: uid).snapshots();
  }
}