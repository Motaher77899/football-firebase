// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:intl/intl.dart';
// import '../data/bd_data.dart';
// import '../providers/auth_provider.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _fullNameController;
//
//   String? _selectedDivision;
//   String? _selectedDistrict;
//   String? _selectedUpazila;
//   String? _selectedGender;
//   DateTime? _selectedDate;
//
//   List<String> _districts = [];
//   List<String> _upazilas = [];
//
//   @override
//   void initState() {
//     super.initState();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final user = authProvider.currentUser;
//
//     if (user != null) {
//       _fullNameController = TextEditingController(text: user.fullName);
//       _selectedDivision = user.division;
//       _selectedDistrict = user.district;
//       _selectedUpazila = user.upazila;
//       _selectedGender = user.gender;
//       _selectedDate = user.dateOfBirth;
//
//       _districts = BDInfo.getDistrictsByDivision(user.division);
//       _upazilas = BDInfo.getUpazilasByDistrict(user.district);
//     } else {
//       _fullNameController = TextEditingController();
//     }
//   }
//
//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     super.dispose();
//   }
//
//   void _onDivisionChanged(String? division) {
//     setState(() {
//       _selectedDivision = division;
//       _selectedDistrict = null;
//       _selectedUpazila = null;
//       _districts = division != null ? BDInfo.getDistrictsByDivision(division) : [];
//       _upazilas = [];
//     });
//   }
//
//   void _onDistrictChanged(String? district) {
//     setState(() {
//       _selectedDistrict = district;
//       _selectedUpazila = null;
//       _upazilas = district != null ? BDInfo.getUpazilasByDistrict(district) : [];
//     });
//   }
//
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime(2000),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: Color(0xFF0F3460),
//               onPrimary: Colors.white,
//               surface: Color(0xFF16213E),
//               onSurface: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   Future<void> _handleSave() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     if (_selectedDivision == null ||
//         _selectedDistrict == null ||
//         _selectedUpazila == null ||
//         _selectedGender == null ||
//         _selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('সকল তথ্য পূরণ করুন'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     bool success = await authProvider.updateProfile(
//       fullName: _fullNameController.text.trim(),
//       division: _selectedDivision!,
//       district: _selectedDistrict!,
//       upazila: _selectedUpazila!,
//       gender: _selectedGender!,
//       dateOfBirth: _selectedDate!,
//     );
//
//     if (mounted) {
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('প্রোফাইল আপডেট সফল হয়েছে'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               authProvider.errorMessage ?? 'প্রোফাইল আপডেট ব্যর্থ হয়েছে',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16213E),
//         elevation: 0,
//         title: const Text(
//           'প্রোফাইল সম্পাদনা',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Full Name
//               _buildTextField(
//                 controller: _fullNameController,
//                 label: 'পূর্ণ নাম',
//                 icon: Icons.person,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'নাম লিখুন';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               // Division Dropdown
//               _buildDropdown(
//                 label: 'বিভাগ',
//                 icon: Icons.location_city,
//                 value: _selectedDivision,
//                 items: BDInfo.divisions,
//                 onChanged: _onDivisionChanged,
//               ),
//               const SizedBox(height: 16),
//
//               // District Dropdown
//               _buildDropdown(
//                 label: 'জেলা',
//                 icon: Icons.map,
//                 value: _selectedDistrict,
//                 items: _districts,
//                 onChanged: _onDistrictChanged,
//                 enabled: _selectedDivision != null,
//               ),
//               const SizedBox(height: 16),
//
//               // Upazila Dropdown
//               _buildDropdown(
//                 label: 'উপজেলা',
//                 icon: Icons.place,
//                 value: _selectedUpazila,
//                 items: _upazilas,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedUpazila = value;
//                   });
//                 },
//                 enabled: _selectedDistrict != null,
//               ),
//               const SizedBox(height: 16),
//
//               // Gender
//               _buildDropdown(
//                 label: 'লিঙ্গ',
//                 icon: Icons.wc,
//                 value: _selectedGender,
//                 items: const ['পুরুষ', 'মহিলা', 'অন্যান্য'],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedGender = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Date of Birth
//               InkWell(
//                 onTap: _selectDate,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF16213E),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.1),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.cake, color: Colors.white54),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           _selectedDate == null
//                               ? 'জন্ম তারিখ নির্বাচন করুন'
//                               : DateFormat('dd MMMM yyyy')
//                               .format(_selectedDate!),
//                           style: TextStyle(
//                             color: _selectedDate == null
//                                 ? Colors.white54
//                                 : Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       const Icon(Icons.calendar_today, color: Colors.white54),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//
//               // Save Button
//               Consumer<AuthProvider>(
//                 builder: (context, authProvider, child) {
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: authProvider.isLoading ? null : _handleSave,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0F3460),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: authProvider.isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         'সংরক্ষণ করুন',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white54),
//         prefixIcon: Icon(icon, color: Colors.white54),
//         filled: true,
//         fillColor: const Color(0xFF16213E),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Colors.white.withOpacity(0.1),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(
//             color: Color(0xFF0F3460),
//             width: 2,
//           ),
//         ),
//       ),
//       validator: validator,
//     );
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required IconData icon,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     bool enabled = true,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: enabled ? const Color(0xFF16213E) : Colors.grey.shade800,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white54),
//           const SizedBox(width: 12),
//           Expanded(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: value,
//                 isExpanded: true,
//                 hint: Text(
//                   label,
//                   style: const TextStyle(color: Colors.white54),
//                 ),
//                 dropdownColor: const Color(0xFF16213E),
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//                 items: enabled
//                     ? items.map((String item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList()
//                     : [],
//                 onChanged: enabled ? onChanged : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import '../data/bd_data.dart'; // ধরে নিলাম এই ফাইলটি আছে
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedUpazila;
  String? _selectedGender;
  DateTime? _selectedDate;

  List<String> _districts = [];
  List<String> _upazilas = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      _fullNameController = TextEditingController(text: user.fullName);
      _selectedDivision = user.division;
      _selectedDistrict = user.district;
      _selectedUpazila = user.upazila;
      _selectedGender = user.gender;
      _selectedDate = user.dateOfBirth;

      _districts = BDInfo.getDistrictsByDivision(user.division);
      _upazilas = BDInfo.getUpazilasByDistrict(user.district);
    } else {
      _fullNameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  void _onDivisionChanged(String? division) {
    setState(() {
      _selectedDivision = division;
      _selectedDistrict = null;
      _selectedUpazila = null;
      _districts = division != null ? BDInfo.getDistrictsByDivision(division) : [];
      _upazilas = [];
    });
  }

  void _onDistrictChanged(String? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedUpazila = null;
      _upazilas = district != null ? BDInfo.getUpazilasByDistrict(district) : [];
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0F3460),
              onPrimary: Colors.white,
              surface: Color(0xFF16213E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDivision == null ||
        _selectedDistrict == null ||
        _selectedUpazila == null ||
        _selectedGender == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('সকল তথ্য পূরণ করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.updateProfile(
      fullName: _fullNameController.text.trim(),
      division: _selectedDivision!,
      district: _selectedDistrict!,
      upazila: _selectedUpazila!,
      gender: _selectedGender!,
      dateOfBirth: _selectedDate!,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('প্রোফাইল আপডেট সফল হয়েছে'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'প্রোফাইল আপডেট ব্যর্থ হয়েছে',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          'প্রোফাইল সম্পাদনা',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              _buildTextField(
                controller: _fullNameController,
                label: 'পূর্ণ নাম',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'নাম লিখুন';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Division Dropdown
              _buildDropdown(
                label: 'বিভাগ',
                icon: Icons.location_city,
                value: _selectedDivision,
                items: BDInfo.divisions,
                onChanged: _onDivisionChanged,
              ),
              const SizedBox(height: 16),

              // District Dropdown
              _buildDropdown(
                label: 'জেলা',
                icon: Icons.map,
                value: _selectedDistrict,
                items: _districts,
                onChanged: _onDistrictChanged,
                enabled: _selectedDivision != null,
              ),
              const SizedBox(height: 16),

              // Upazila Dropdown
              _buildDropdown(
                label: 'উপজেলা',
                icon: Icons.place,
                value: _selectedUpazila,
                items: _upazilas,
                onChanged: (value) {
                  setState(() {
                    _selectedUpazila = value;
                  });
                },
                enabled: _selectedDistrict != null,
              ),
              const SizedBox(height: 16),

              // Gender
              _buildDropdown(
                label: 'লিঙ্গ',
                icon: Icons.wc,
                value: _selectedGender,
                items: const ['পুরুষ', 'মহিলা', 'অন্যান্য'],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cake, color: Colors.white54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'জন্ম তারিখ নির্বাচন করুন'
                              : DateFormat('dd MMMM yyyy')
                              .format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Colors.white54
                                : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3460),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'সংরক্ষণ করুন',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF16213E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0F3460),
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF16213E) : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: Text(
                  label,
                  style: const TextStyle(color: Colors.white54),
                ),
                dropdownColor: const Color(0xFF16213E),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: enabled
                    ? items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList()
                    : [],
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}