import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabWidget2 extends StatefulWidget {
  const TabWidget2({Key? key}) : super(key: key);

  @override
  _TabWidget2State createState() => _TabWidget2State();
}

class _TabWidget2State extends State<TabWidget2> {
  late final SupabaseClient _supabaseClient;
  late final Stream<List<Map<String, dynamic>>> _roomStream;


  int? selected_building;

  Future<String> _fetchImageUrl(String bucketName, String filePath) async {
    try {
      final response = await _supabaseClient.storage.from(bucketName).getPublicUrl(filePath);

      if (response == null) {
        throw Exception('Error fetching image URL');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    // // Initialize Supabase BG
    // _supabaseClient = SupabaseClient(
    //   'https://cydkhfrmsecjrfrfklyt.supabase.co',
    //   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5ZGtoZnJtc2VjanJmcmZrbHl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY5MDM2MDAsImV4cCI6MjA0MjQ3OTYwMH0.4Ck0avMzkx1Icj_T1qRyQpt_sl-16HsLTlzg3uRyRlc',
    // );

    // Fetch room data as a stream
    _roomStream = _supabaseClient.from('BUILDING').stream(primaryKey: ['build_id']);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('building'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _roomStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No build found.'));
          } else {
            final build = snapshot.data!;
            return ListView.builder(
              itemCount: build.length,
              itemBuilder: (context, index) {
                final builds = build[index];
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          _supabaseClient.storage.from("boarding-house-images").getPublicUrl("${builds['build_name']}/buildingProfile.jpg"),
                        ),
                        fit: BoxFit.cover,
                      ),

                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                        Colors.black.withOpacity(0.6), // Overlay for visibility
                        backgroundColor: Colors.black.withOpacity(0.6),
                        title: Text(
                          builds['build_name'] ?? 'No name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          'User ID: ${builds['build_id'] ?? 'Unknown'}',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              builds['build_description'] ?? 'No details available.',

                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected_building = builds['build_id'];
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('build selected: ${builds['build_id']}'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                // Optional: Do something here
                                print('Confirmed Room ID: ${builds['build_id']}');
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(builds['build_id'].toString()),
                    ),

                    ],
                      ),
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
