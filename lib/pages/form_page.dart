import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/theme.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_text_field.dart';
import '../service/api_service.dart';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? item;
  const FormPage({super.key, this.item});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _costController;
  late TextEditingController _lastDateController;
  late TextEditingController _nextDateController;

  String _status = 'scheduled';
  File? _imageFile;
  bool _loading = false;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _itemNameController = TextEditingController(text: item?['item_name'] ?? '');
    _serviceTypeController = TextEditingController(
      text: item?['service_type'] ?? '',
    );
    _costController = TextEditingController(
      text: item?['cost']?.toString() ?? '',
    );
    _lastDateController = TextEditingController(
      text: item?['last_service_date'] ?? '',
    );
    _nextDateController = TextEditingController(
      text: item?['next_service_date'] ?? '',
    );
    _status = item?['status'] ?? 'scheduled';
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final fields = {
      'item_name': _itemNameController.text,
      'service_type': _serviceTypeController.text,
      'cost': _costController.text,
      'last_service_date': _lastDateController.text,
      'next_service_date': _nextDateController.text,
      'status': _status,
    };

    try {
      if (_isEdit) {
        await ApiService.putMultipart(
          '/maintenances/${widget.item!['id']}',
          fields,
          _imageFile,
        );
      } else {
        await ApiService.postMultipart('/maintenances', fields, _imageFile);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit catatan' : 'Catatan baru')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppTextField(
                  label: 'Nama Barang',
                  hint: 'Laptop, motor, AC',
                  controller: _itemNameController,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: AppTheme.gap14),
                AppTextField(
                  label: 'Jenis Servis',
                  hint: 'Ganti oli, install ulang',
                  controller: _serviceTypeController,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: AppTheme.gap14),
                AppTextField(
                  label: 'Biaya (Rp)',
                  hint: '150000',
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: AppTheme.gap14),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Tgl Servis',
                        hint: 'Pilih tanggal',
                        controller: _lastDateController,
                        readOnly: true,
                        onTap: () => _pickDate(_lastDateController),
                        validator: (v) => v!.isEmpty ? 'Wajib' : null,
                      ),
                    ),
                    const SizedBox(width: AppTheme.gap10),
                    Expanded(
                      child: AppTextField(
                        label: 'Tgl Berikutnya',
                        hint: 'Pilih tanggal',
                        controller: _nextDateController,
                        readOnly: true,
                        onTap: () => _pickDate(_nextDateController),
                        validator: (v) => v!.isEmpty ? 'Wajib' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.gap14),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: AppTheme.paper,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.rbS),
                      borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.rbS),
                      borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'scheduled',
                      child: Text('Terjadwal'),
                    ),
                    DropdownMenuItem(value: 'done', child: Text('Selesai')),
                  ],
                  onChanged: (v) => setState(() => _status = v!),
                ),
                const SizedBox(height: AppTheme.gap14),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.paper,
                      borderRadius: BorderRadius.circular(AppTheme.rbS),
                      border: Border.all(color: const Color(0xFFE5E0D8)),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.rbS),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined, size: 28),
                                SizedBox(height: AppTheme.gap6),
                                Text('Pilih gambar (opsional)'),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppTheme.gap28),
                AppButton(
                  label: _isEdit ? 'Simpan perubahan' : 'Simpan catatan',
                  onTap: _submit,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
