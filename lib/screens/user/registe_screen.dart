import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/input_field.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/password.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

class RegisteScreen extends ConsumerStatefulWidget {
  const RegisteScreen({super.key});

  @override
  ConsumerState<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends ConsumerState<RegisteScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  DateTime? selectedDate;
  bool receiveEmails = true;
  String? errorText;

  String get formattedDate {
    if (selectedDate == null) return "";
    return DateFormat("MM/dd/yyyy").format(selectedDate!);
  }

  bool get isDobValid {
    if (selectedDate == null) return false;
    final now = DateTime.now();
    int age = now.year - selectedDate!.year;

    if (now.month < selectedDate!.month ||
        (now.month == selectedDate!.month && now.day < selectedDate!.day)) {
      age--;
    }
    return age >= 13;
  }

  void openDatePicker() async {
    final date = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(2004),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM_yyyy",
      locale: DateTimePickerLocale.en_us,
      titleText: "Date of Birth",
      textColor: Colors.white,
      backgroundColor: const Color(0xff2b2d31),
      itemTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      looping: false,
      confirmText: "CONFIRM",
      cancelText: "CANCEL",
    );

    if (date != null) {
      final age = DateTime.now().year - date.year;
      setState(() {
        errorText = age < 13 ? "Please enter a valid date of birth" : null;
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0f7b2f), Color(0xff12b13d)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Create Your\nAccount",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        InputField(hint: "Email", controller: emailController),
                        const SizedBox(height: 12),
                        Password(controller: passwordController),
                        SizedBox(height: 8),
                        Text(
                          "Date of Birth",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: openDatePicker,
                          child: Container(
                            height: 58,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              selectedDate == null
                                  ? "DD / MM / YYYY"
                                  : formattedDate,
                              style: TextStyle(
                                color: selectedDate == null
                                    ? Colors.white38
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                errorText!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: uiColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),

                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        RichText(
                          text: const TextSpan(
                            text: "Don’t have account? ",
                            style: TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(
                                  color: uiColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
