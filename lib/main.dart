import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'BGuser_list.dart';
import 'BGrooms.dart';
import 'BGadd_room.dart';
import 'MH_fetch_user_data.dart';
import 'MH_add_room.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wwnayjgntdptacsbsnus.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3bmF5amdudGRwdGFjc2JzbnVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5NTU0MzMsImV4cCI6MjA0ODUzMTQzM30.w3E77UKpHnnhpe7Q3IEBXJhMdB3UP7Fvux9PQf7dxi0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();

  // Initialize the stream
  late final Stream<List<Map<String, dynamic>>> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = Supabase.instance.client
        .from('USER')
        .stream(primaryKey: ['user_id'])
        .order('user_id');
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Supabase Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textController1,
              decoration: const InputDecoration(labelText: 'Enter username'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _textController2,
              decoration: const InputDecoration(labelText: 'Enter password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserListPage()),
                );
              },
              child: const Text('Go to User List'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabWidget2()),
                );
              },
              child: const Text('Go to Room List'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRoomPage()),
                );
              },
              child: const Text('Go to Room List'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
              child: const Text('Go to USer Profile'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRoom()),
                );
              },
              child: const Text('Go to MIHOMY add room'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
