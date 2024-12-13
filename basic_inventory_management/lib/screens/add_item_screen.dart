import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/db/database_helper.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  File? _image;

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'price': double.parse(_priceController.text),
        'stock': _stockController.text,
        'imagePath': _image?.path ?? ''
      };
      await DatabaseHelper().insertItem(newItem);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Barang')),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Deskripsi')),
              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Kategori')),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
              TextFormField(controller: _stockController, decoration: const InputDecoration(labelText: 'Stok'), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _image != null ? Image.file(_image!, width: 100, height: 100) : const Text('Belum ada gambar yang dipilih'),
              ElevatedButton(onPressed: _pickImageFromCamera, child: const Icon(Icons.camera_alt)),
              ElevatedButton(
                onPressed: _saveData, child: const Text('Simpan Data')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
