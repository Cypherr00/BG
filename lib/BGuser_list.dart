import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final Stream<List<Map<String, dynamic>>> _buildStream;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _buildStream = supabase.from('BUILDING').stream(primaryKey: ['build']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Building List'),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _buildStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buildings found.'));
          } else {
            final buildings = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: buildings.length,
              itemBuilder: (context, index) {
                final building = buildings[index];
                return Center(
                  child: Container(
                    width: 800,
                    height: 300,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/room.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ExpansionTile(
                      backgroundColor: Colors.black, // Semi-transparent overlay for text readability
                      title: Text(
                        building['build_name'] ?? 'No name',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Build ID: " +
                        building['build_id'],
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Additional Info Here',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
