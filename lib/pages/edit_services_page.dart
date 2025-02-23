import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/responsive_layout.dart';

class EditServicesPage extends StatefulWidget {
  const EditServicesPage({super.key});

  @override
  State<EditServicesPage> createState() => _EditServicesPageState();
}

class _EditServicesPageState extends State<EditServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Services'),
      ),
      body: const Center(
        child: Text('Edit Services Content'),
      ),
    );
  }
}
