import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({Key? key}) : super(key: key);

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController = TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();

  final supabase = Supabase.instance.client;

  void _addRoom() async {
    final roomName = _roomNameController.text;
    final roomDescription = _roomDescriptionController.text;
    final roomPrice = int.tryParse(_roomPriceController.text) ?? 0;

    if (roomName.isNotEmpty && roomDescription.isNotEmpty && roomPrice > 0) {
      final response = await supabase.from('ROOMS').insert({
        'room_name': roomName,
        'room_description': roomDescription,
        'room_price': roomPrice,
      });  // Execute the insert query

      // Check for response errors
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room added successfully!')),
        );
        _roomNameController.clear();
        _roomDescriptionController.clear();
        _roomPriceController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error?.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _roomDescriptionController,
              maxLines: null, // To allow for multiple lines of input
              decoration: const InputDecoration(
                labelText: 'Room Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _roomPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Room Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addRoom,
              child: const Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }
}
