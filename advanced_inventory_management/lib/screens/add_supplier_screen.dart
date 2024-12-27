import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class AddSupplierScreen extends StatefulWidget {
  final Map<String, dynamic>? supplier;

  const AddSupplierScreen({super.key, this.supplier});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!['name'] ?? '';
      _addressController.text = widget.supplier!['address'] ?? '';
      _contactController.text = widget.supplier!['contact'] ?? '';
      _latitude = widget.supplier!['latitude'] ?? '';
      _longitude = widget.supplier!['longitude'] ?? '';
    }
  }

  Future<void> _getLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }
      final locData = await location.getLocation();
      setState(() {
        _latitude = locData.latitude?.toStringAsFixed(6) ?? '';
        _longitude = locData.longitude?.toStringAsFixed(6) ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error mendapatkan lokasi: $e')),
      );
    }
  }

  Future<void> _saveSupplier() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text,
        'address': _addressController.text,
        'contact': _contactController.text,
        'latitude': _latitude,
        'longitude': _longitude,
      };

      try {
        if (widget.supplier == null) {
          await _firestore.collection('suppliers').add(data);
        } else {
          await _firestore.collection('suppliers').doc(widget.supplier!['id']).update(data);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Supplier'),
                  validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (value) => value == null || value.isEmpty ? 'Alamat wajib diisi' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Kontak'),
                  validator: (value) => value == null || value.isEmpty ? 'Kontak wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _getLocation,
                  child: const Text('Ambil Lokasi Supplier'),
                ),
                if (_latitude.isNotEmpty && _longitude.isNotEmpty)
                  Text('Koordinat: $_latitude, $_longitude'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveSupplier,
                  child: const Text('Simpan Supplier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
