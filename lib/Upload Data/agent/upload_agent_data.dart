import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houszscore/Upload%20Data/agent/agent_modal.dart';
import 'package:path_provider/path_provider.dart';

class UploadAgentsScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  UploadAgentsScreen({Key? key}) : super(key: key);

  Future<File> getAssetFile(String assetPath, String fileName) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<String> uploadImage(String assetPath, String fileName) async {
    final file = await getAssetFile(assetPath, fileName);
    final ref = storage.ref().child('agent_images/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<List<String>> fetchPropertyIds() async {
    try {
      final QuerySnapshot snapshot =
          await firestore.collection('properties').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  Future<void> createDummyAgents() async {
    try {
      const String assetPath = 'assets/images/victoria.png';
      const String fileName = 'default_agent_image.png';
      final String imageUrl = await uploadImage(assetPath, fileName);

      final List<String> agentNames = List.generate(
        15,
        (index) => 'Agent ${index + 1}',
      );

      final Random random = Random();
      final List<String> propertyIds = await fetchPropertyIds();

      if (propertyIds.isEmpty) {
        print('No properties found in Firestore.');
        return;
      }
      for (int i = 0; i < agentNames.length; i++) {
        final String agentId = 'agent${i + 1}';

        propertyIds.shuffle(random);

        final List<String> assignedPropertyIds =
            propertyIds.take(random.nextInt(15) + 1).toList();

        final Agent agent = Agent(
          agentId: agentId,
          name: agentNames[i],
          imageUrl: imageUrl,
          licenseNumber: (1000000 + random.nextInt(9000000)).toString(),
          rating: (4.0 + random.nextDouble()).clamp(4.0, 5.0),
          email:
              '${agentNames[i].toLowerCase().replaceAll(" ", ".")}@gmail.com',
          phone:
              '+1 ${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}',
          propertyIds: assignedPropertyIds,
        );

        await firestore.collection('property_agents').add(agent.toMap());
      }

      print('15 dummy agents created successfully with properties!');
    } catch (e) {
      print('Error creating dummy agents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Agents'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await createDummyAgents();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Agents uploaded successfully!')),
            );
          },
          child: const Text('Create Dummy Agents'),
        ),
      ),
    );
  }
}
