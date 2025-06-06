import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cast_input_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cinema_app/shared/widgets/app_button.dart';
// import 'package:cinema_app/cinema_features/cinema_home/presentation/widgets/cast_input_section.dart';
import 'dart:io';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _trailerUrlController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  // Image handling
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<Cast> _casts = [];

  // Scheduling variables
  ShowScheduleType _scheduleType = ShowScheduleType.oneTime;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _recurringStartDate;
  DateTime? _recurringEndDate;
  Map<DayOfWeek, bool> _recurringDays = {
    DayOfWeek.monday: false,
    DayOfWeek.tuesday: false,
    DayOfWeek.wednesday: false,
    DayOfWeek.thursday: false,
    DayOfWeek.friday: false,
    DayOfWeek.saturday: false,
    DayOfWeek.sunday: false,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _lengthController.dispose();
    _descriptionController.dispose();
    _trailerUrlController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState?.reset();
      _titleController.clear();
      _genreController.clear();
      _lengthController.clear();
      _descriptionController.clear();
      _trailerUrlController.clear();
      _costController.clear();
      _imageFile = null;
      _casts = [];
      _scheduleType = ShowScheduleType.oneTime;
      _selectedDate = null;
      _selectedTime = null;
      _recurringStartDate = null;
      _recurringEndDate = null;
      _recurringDays = {
        DayOfWeek.monday: false,
        DayOfWeek.tuesday: false,
        DayOfWeek.wednesday: false,
        DayOfWeek.thursday: false,
        DayOfWeek.friday: false,
        DayOfWeek.saturday: false,
        DayOfWeek.sunday: false,
      };
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$',
    );
    return youtubeRegex.hasMatch(url);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _selectRecurringStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _recurringStartDate) {
      setState(() {
        _recurringStartDate = picked;
        if (_recurringEndDate != null && _recurringEndDate!.isBefore(picked)) {
          _recurringEndDate = null;
        }
      });
    }
  }

  Future<void> _selectRecurringEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recurringStartDate ?? DateTime.now(),
      firstDate: _recurringStartDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _recurringEndDate) {
      setState(() => _recurringEndDate = picked);
    }
  }

  void _toggleDay(DayOfWeek day) {
    setState(() {
      _recurringDays[day] = !_recurringDays[day]!;
    });
  }

  Future<void> _showCastInputDialog() async {
    final List<Cast>? updatedCasts = await showDialog<List<Cast>>(
      context: context,
      builder: (context) {
        return CastInputSection(
          initialCasts: _casts,
          onCastsAdded: (casts) => casts,
        );
      },
    );

    if (updatedCasts != null) {
      setState(() {
        _casts = updatedCasts;
      });
    }
  }

  Future<void> _submitMovie() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a movie poster image')),
      );
      return;
    }

    if (_casts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one cast member')),
      );
      return;
    }

    if (_scheduleType == ShowScheduleType.oneTime) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time for one-time show')),
        );
        return;
      }
    } else {
      if (_recurringStartDate == null || _selectedTime == null || !_recurringDays.containsValue(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select all required fields for recurring show')),
        );
        return;
      }
    }

    // Default to 3 months if end date not provided
    final effectiveEndDate = _recurringEndDate ?? 
        (_recurringStartDate?.add(const Duration(days: 90)));

    // TODO: Implement Firebase upload
    // 1. Upload movie poster
    // 2. Upload cast images
    // 3. Add movie data with references to cast images

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie added successfully!')),
    );
    _clearForm();
  }

  List<Map<String, dynamic>> _getShowTimes(DateTime? effectiveEndDate) {
    if (_scheduleType == ShowScheduleType.oneTime) {
      return [
        {
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
          'time': _selectedTime!.format(context),
          'isRecurring': false,
        }
      ];
    } else {
      final List<Map<String, dynamic>> showTimes = [];
      final days = _recurringDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      DateTime currentDate = _recurringStartDate!;
      final endDate = effectiveEndDate ?? currentDate.add(const Duration(days: 90));
      
      while (currentDate.isBefore(endDate)) {
        for (var day in days) {
          if (currentDate.weekday == day.index + 1) {
            showTimes.add({
              'date': DateFormat('yyyy-MM-dd').format(currentDate),
              'time': _selectedTime!.format(context),
              'isRecurring': true,
              'dayOfWeek': day.toString(),
            });
          }
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
      return showTimes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Add New Movie'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Title
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Movie Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a movie title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Genre
              TextFormField(
                controller: _genreController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a genre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Movie Length
              TextFormField(
                controller: _lengthController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Movie Length (e.g. 1:30:25)',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter movie length';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Ticket Cost
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Ticket Cost',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  prefixText: '\$ ',
                  prefixStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ticket cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Movie Poster Image
              const Text(
                'Movie Poster:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, color: Colors.grey, size: 40),
                              SizedBox(height: 8),
                              Text('Tap to add poster image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),

              // Cast Section
              const Text(
                'Cast Members',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showCastInputDialog,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Add Cast Members',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  child: Text(
                    _casts.isEmpty
                        ? 'Tap to add cast members'
                        : _casts.map((c) => c.name).join(', '),
                    style: TextStyle(
                      color: _casts.isEmpty ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
              ),
              if (_casts.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _casts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: FileImage(_casts[index].imageFile),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Trailer URL
              TextFormField(
                controller: _trailerUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'YouTube Trailer URL',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trailer URL';
                  }
                  if (!_isValidYouTubeUrl(value)) {
                    return 'Please enter a valid YouTube URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Schedule Type
              const Text(
                'Show Time Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Radio<ShowScheduleType>(
                    value: ShowScheduleType.oneTime,
                    groupValue: _scheduleType,
                    onChanged: (value) {
                      setState(() => _scheduleType = value!);
                    },
                    activeColor: Colors.green,
                  ),
                  const Text(
                    'One-Time Show',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Radio<ShowScheduleType>(
                    value: ShowScheduleType.recurring,
                    groupValue: _scheduleType,
                    onChanged: (value) {
                      setState(() => _scheduleType = value!);
                    },
                    activeColor: Colors.green,
                  ),
                  const Text(
                    'Recurring Show',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Schedule Fields
              if (_scheduleType == ShowScheduleType.oneTime) ...[
                // One-Time Show Fields
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          child: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Recurring Show Fields
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectRecurringStartDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          child: Text(
                            _recurringStartDate == null
                                ? 'Select Start Date'
                                : DateFormat('MMM dd, yyyy').format(_recurringStartDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectRecurringEndDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'End Date (optional)',
                            labelStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: _recurringEndDate == null
                                ? const Tooltip(
                                    message: 'If not set, will default to 3 months from start date',
                                    child: Icon(Icons.info_outline, color: Colors.grey, size: 18),
                                  )
                                : null,
                          ),
                          child: Text(
                            _recurringEndDate == null
                                ? 'Not set (default: 3 months)'
                                : DateFormat('MMM dd, yyyy').format(_recurringEndDate!),
                            style: TextStyle(
                              color: _recurringEndDate == null ? Colors.grey : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Show Time',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : _selectedTime!.format(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recurring Days:',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: DayOfWeek.values.map((day) {
                    return FilterChip(
                      label: Text(
                        day.toString().split('.').last,
                        style: TextStyle(
                          color: _recurringDays[day]! ? Colors.white : Colors.grey,
                        ),
                      ),
                      selected: _recurringDays[day]!,
                      onSelected: (selected) => _toggleDay(day),
                      selectedColor: Colors.green,
                      backgroundColor: const Color(0xFF2d2d2d),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 40),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Clear',
                      backgroundColor: Colors.red,
                      onPressed: _clearForm,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: 'Post Movie',
                      onPressed: _submitMovie,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

enum ShowScheduleType { oneTime, recurring }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}