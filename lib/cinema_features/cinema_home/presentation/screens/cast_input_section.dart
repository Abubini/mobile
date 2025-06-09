import 'package:flutter/material.dart';

class CastInputSection extends StatefulWidget {
  final List<Map<String, String>> initialCasts;
  
  const CastInputSection({
    super.key,
    required this.initialCasts,
  });

  @override
  State<CastInputSection> createState() => _CastInputSectionState();
}

class _CastInputSectionState extends State<CastInputSection> {
  final List<Map<String, String>> _casts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _casts.addAll(widget.initialCasts);
  }

  void _addCast() {
    if (_nameController.text.isEmpty || 
        _imageUrlController.text.isEmpty || 
        _casts.length >= 5) return;

    setState(() {
      _casts.add({
        'name': _nameController.text,
        'imageUrl': _imageUrlController.text,
      });
      _nameController.clear();
      _imageUrlController.clear();
    });
  }

  void _removeCast(int index) {
    setState(() {
      _casts.removeAt(index);
    });
  }

  void _submitCasts() {
    Navigator.pop(context, _casts);
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
              TextFormField(
                controller: _imageUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cast Image URL',
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
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
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
                  children: _casts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final cast = entry.value;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(cast['imageUrl']!),
                      ),
                      title: Text(
                        cast['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCast(index),
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