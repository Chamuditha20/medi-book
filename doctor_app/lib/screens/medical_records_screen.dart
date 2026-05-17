import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/record_provider.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // පිටුව ලෝඩ් වෙද්දීම වාර්තා ටික අදින්න කියනවා
    Future.microtask(() => Provider.of<RecordProvider>(context, listen: false).fetchRecords());
  }

  // ෆොටෝ එකක් තෝරලා Upload කරන Function එක
  Future<void> _pickAndUploadImage() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title first!'), backgroundColor: Colors.orange));
      return;
    }

    final ImagePicker picker = ImagePicker();
    // Gallery එකෙන් ෆොටෝ එකක් තෝරන්න දෙනවා
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      final success = await Provider.of<RecordProvider>(context, listen: false).uploadRecord(_titleController.text.trim(), image);
      
      if (success) {
        _titleController.clear();
        if (mounted) Navigator.pop(context); // Dialog එක වහනවා
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record Uploaded! 🎉'), backgroundColor: Colors.green));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload Failed!'), backgroundColor: Colors.red));
      }
    }
  }

  // අලුත් වාර්තාවක් දාන කොටුව (Dialog)
  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'E.g., Blood Test Report', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickAndUploadImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image & Upload'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Medical Records')),
      body: provider.isLoading && provider.records.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : provider.records.isEmpty
              ? const Center(child: Text('No records found. Add your first record!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.records.length,
                  itemBuilder: (context, index) {
                    final record = provider.records[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Storage එකෙන් එන Public URL එක කෙලින්ම පෙන්වනවා
                          Image.network(
                            record['image_url'],
                            height: 200, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(record['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}