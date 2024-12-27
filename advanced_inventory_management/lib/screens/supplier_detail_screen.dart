import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierDetailScreen extends StatelessWidget {
  final Map<String, dynamic> supplier;

  const SupplierDetailScreen({Key? key, required this.supplier})
      : super(key: key);

  /*
  void _openGoogleMaps(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }*/

  void _openStreetMap(double latitude, double longitude) async {
    final openStreetMapUrl =
    Uri.parse('https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude&zoom=15');

    if (await canLaunchUrl(openStreetMapUrl)) {
      await launchUrl(openStreetMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open OpenStreetMap';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double latitude = double.parse(supplier['latitude']);
    final double longitude = double.parse(supplier['longitude']);

    return Scaffold(
      appBar: AppBar(
        title: Text(supplier['name'] ?? 'Detail Supplier'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplier['name'] ?? 'Nama Tidak Tersedia',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Alamat: ${supplier['address'] ?? 'Alamat Tidak Tersedia'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Kontak: ${supplier['contact'] ?? 'Kontak Tidak Tersedia'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Koordinat: (${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)})',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Peta Lokasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(latitude, longitude),
                  zoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _openStreetMap(latitude, longitude),
              icon: const Icon(Icons.map),
              label: const Text('Buka di Google Maps'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
