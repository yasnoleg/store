import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String dropdownValue = 'اكواب';
  final TextEditingController pictureUrlController = TextEditingController();
  final TextEditingController hightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //
  List<String> list = ['اكواب','فلاتر','مستلزمات التنظيف','مكينة قهوة'];

  void _uploadProduct() async {
    // Get the values from the text controllers
    String name = nameController.text;
    String price = priceController.text;
    String bio = bioController.text;
    String type = dropdownValue;
    String pictureUrl = pictureUrlController.text;
    String hight = hightController.text;
    String weight = weightController.text;
    String size = sizeController.text;

    // Create a new document in the 'products' collection
    await firestore.collection('products').add({
      'name': name,
      'price': price,
      'bio': bio,
      'type': type,
      'pictureUrl': pictureUrl,
      'قوة المحرك': hight,
      'الأبعاد': weight,
      'كهرباء الجهاز': size,
    });

    // Clear the input fields
    nameController.clear();
    priceController.clear();
    bioController.clear();
    pictureUrlController.clear();
    hightController.clear();
    weightController.clear();
    sizeController.clear();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to Firestore.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coffee Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              dropdownValue == 'مكينة قهوة' ? TextField(
                controller: sizeController,
                decoration: const InputDecoration(labelText: 'كهرباء'),
              ) : Container(),
              dropdownValue == 'مكينة قهوة' ? TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'الأبعاد'),
              ) : Container(),
              dropdownValue == 'مكينة قهوة' ? TextField(
                controller: hightController,
                decoration: const InputDecoration(labelText: 'قوة المحرك'),
              ) : Container(),
              TextField(
                controller: pictureUrlController,
                decoration: const InputDecoration(labelText: 'pictureUrl'),
              ),
              const SizedBox(height: 20),
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

