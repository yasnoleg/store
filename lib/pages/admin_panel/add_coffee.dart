import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String price;
  String type;
  String status;
  List<String> weight;
  List<String> tags;
  String pictureUrl;
  String power;
  String degree;
  String companies;

  Product({
    required this.name,
    required this.price,
    required this.type,
    required this.status,
    required this.weight,
    required this.tags,
    required this.pictureUrl,
    required this.power,
    required this.degree,
    required this.companies,
  });
}

class AdminUploadCoffee extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController pictureUrlController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController companiesController = TextEditingController();
  final TextEditingController collectionController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AdminUploadCoffee({super.key});

  void _uploadProduct() async {
    Product product = Product(
      name: nameController.text,
      price: priceController.text,
      type: typeController.text,
      status: statusController.text,
      weight: weightController.text.split('-'),
      tags: tagsController.text.split('-'),
      pictureUrl: pictureUrlController.text,
      power: powerController.text,
      degree: degreeController.text,
      companies: companiesController.text,
    );

    await firestore.collection(collectionController.text.trim()).add({
      'name': product.name,
      'price': product.price,
      'السلالة': product.type,
      'المعالجة': product.status,
      'القوام': product.power,
      'درجة التحميص': product.degree,
      'weight': product.weight,
      'tags': product.tags,
      'pictureUrl': product.pictureUrl,
      'الشركة': product.companies,
    });

    // Clear text fields after uploading
    nameController.clear();
    priceController.clear();
    typeController.clear();
    statusController.clear();
    weightController.clear();
    tagsController.clear();
    pictureUrlController.clear();
    powerController.clear();
    degreeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Product to Firestore'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'السلالة'),
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'المعالجة'),
              ),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
              ),
              TextFormField(
                controller: tagsController,
                decoration: const InputDecoration(labelText: 'Tags (comma-separated)'),
              ),
              TextFormField(
                controller: powerController,
                decoration: const InputDecoration(labelText: 'القوام'),
              ),
              TextFormField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'درجة التحميص'),
              ),
              TextFormField(
                controller: companiesController,
                decoration: const InputDecoration(labelText: 'الشركة'),
              ),
              TextFormField(
                controller: pictureUrlController,
                decoration: const InputDecoration(labelText: 'Picture URL'),
              ),
              TextFormField(
                controller: collectionController,
                decoration: const InputDecoration(labelText: 'Where "collection" '),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploadProduct,
                child: const Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
