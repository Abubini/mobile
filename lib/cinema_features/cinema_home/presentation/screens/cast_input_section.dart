import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CastInputSection extends StatefulWidget {
  final List<Cast> initialCasts;
  final Function(List<Cast>) onCastsAdded;

  const CastInputSection({
    super.key,
    required this.initialCasts,
    required this.onCastsAdded,
  });

  @override
  State<CastInputSection> createState() => _CastInputSectionState();
}

class _CastInputSectionState extends State<CastInputSection> {
  late List<Cast> _casts;
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _casts = List.from(widget.initialCasts);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addCast() {
    if (_nameController.text.isEmpty || _imageFile == null || _casts.length >= 5) return;

    setState(() {
      _casts.add(Cast(
        name: _nameController.text,
        imageFile: _imageFile!,
      ));
      _nameController.clear();
      _imageFile = null;
    });
  }

  void _removeCast(int index) {
    setState(() {
      _casts.removeAt(index);
    });
  }

  void _submitCasts() {
    widget.onCastsAdded(_casts);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1a1a1a),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Cast Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cast Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, color: Colors.grey),
                              Text('Add Photo', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addCast,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Cast Member'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Added Cast Members (max 5)',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              if (_casts.isEmpty)
                const Text(
                  'No cast members added yet',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children: _casts.map((cast) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(cast.imageFile),
                      ),
                      title: Text(
                        cast.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCast(_casts.indexOf(cast)),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _casts.isNotEmpty ? _submitCasts : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Cast {
  final String name;
  final File imageFile;

  Cast({
    required this.name,
    required this.imageFile,
  });
}