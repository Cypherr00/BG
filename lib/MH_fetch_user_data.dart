import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final String userId = '8f35d6a9-a637-4f87-9615-b1c677203b34'; //change this to change the user
  late final SupabaseClient supabase;
  late Future<Map<String, dynamic>> _userData;
  late Future<String> _imageUrl;

  String BuildName = "jb";

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;

    final bucketName = 'boarding-house-images'; //dont need changing since were only using one bucket
    final filePath = "$BuildName/buildingProfile.jpg"; //change this to change the building pic
    //  final filePathRooms = "$BuildName/$selectedRoom/roomProfile.jpg";

    // Fetch user data and image URL asynchronously
    _userData = _fetchUserData(userId);
    _imageUrl = _fetchImageUrl(bucketName, filePath);
  }

  // Function to fetch user data
  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    try {
      final response = await supabase
          .from('USERS')
          .select('user_fullname, user_phonenumber, user_email, user_type')
          .eq('user_id', userId)
          .single();

      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Function to fetch image URL from Supabase Storage
  Future<String> _fetchImageUrl(String bucketName, String filePath) async {
    try {
      final response = await supabase.storage.from(bucketName).getPublicUrl(filePath);

      if (response == null) {
        throw Exception('Error fetching image URL');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Row(
        children: [
          // FutureBuilder for fetching user data
          FutureBuilder<Map<String, dynamic>>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No user data found.'));
              } else {
                final user = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name: ${user['user_fullname']}'),
                      Text('Phone Number: ${user['user_phonenumber']}'),
                      Text('Email: ${user['user_email']}'),
                      Text('User Type: ${user['user_type']}'),
                    ],
                  ),
                );
              }
            },
          ),

          // FutureBuilder for fetching the image URL
          FutureBuilder<String>(
            future: _imageUrl,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final imageUrl = snapshot.data!;
                return Image.network(imageUrl, fit: BoxFit.cover);
              }
            },
          ),
        ],
      ),
    );
  }
}
