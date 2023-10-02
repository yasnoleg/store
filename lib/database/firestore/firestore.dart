import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/database/auth/user_auth.dart';

class FireStore {
  //
  final _firestore = FirebaseFirestore.instance;

  //
  DateTime date = DateTime.now();

  //add request
  AddRequest(String productName, double price , String paymentMethod, int quantity, String clientName, String clientEmail, String clientAddress, String clientPhoneNumber) async {
    await _firestore.collection('requests').add({
      'product name' : productName,
      'price' : price,
      'done' : false,
      'payment method' : paymentMethod,
      'quantity' : quantity,
      'client name' : clientName,
      'client address' : clientAddress,
      'client email' : clientEmail,
      'client phone number' : clientPhoneNumber,
      'date': '${date.day}/${date.month}/${date.year} || ${date.hour}:${date.minute}'
    });
  } 

  CollectionOfRequest(Map products, double price, String PaymentMethod, String clientName, String clientEmail, String clientPhoneNumber, String address) async {
    await _firestore.collection('requests').add({
      'products': products,
      'price': price,
      'payment method': PaymentMethod,
      'done': false,
      'quantity': products.length,
      'client name': clientName,
      'client email': clientEmail,
      'client phone number': clientPhoneNumber,
      'client address' : address,
      'date': '${date.day}/${date.month}/${date.year} || ${date.hour}:${date.minute}'
    });
  }


  //add to fav
  AddToFav(Map<String, dynamic> productInfo) async {
    await _firestore.collection('users').doc(User().id).collection('fav').add(productInfo);
  }
}