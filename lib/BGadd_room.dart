import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDetailsController = TextEditingController();
  final TextEditingController _buildingIdController = TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();

  Future<void> _submitRoomData() async {
    final roomName = _roomNameController.text;
    final roomDetails = _roomDetailsController.text;
    final buildingIdText = _buildingIdController.text;
    final roomPriceText = _roomPriceController.text;


    if (roomName.isEmpty ||
        roomDetails.isEmpty ||
        buildingIdText.isEmpty ||
        roomPriceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    int? buildingId = int.tryParse(buildingIdText);
    double? roomPrice = double.tryParse(roomPriceText);

    if (buildingId == null || roomPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Building ID and Room Price must be valid numbers')),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('ROOMS').insert({
        'room_name': roomName,
        'room_details': roomDetails,
        'building_id': buildingId,
        'room_price': roomPrice,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room added successfully!')),
      );

      // Clear the text fields
      _roomNameController.clear();
      _roomDetailsController.clear();
      _buildingIdController.clear();
      _roomPriceController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomDetailsController.dispose();
    _buildingIdController.dispose();
    _roomPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            TextField(
              controller: _roomDetailsController,
              decoration: const InputDecoration(labelText: 'Room Details'),
            ),
            TextField(
              controller: _buildingIdController,
              decoration: const InputDecoration(labelText: 'Building ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _roomPriceController,
              decoration: const InputDecoration(labelText: 'Room Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitRoomData,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
