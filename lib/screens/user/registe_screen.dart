import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/otp_page.dart';
import 'package:whatsapp_clone/screens/user/display_name.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/input_field.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/password.dart';

class RegisteScreen extends StatefulWidget {
  const RegisteScreen({super.key});

  @override
  State<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends State<RegisteScreen> {
  Country? selectedCountry;
  bool isEmailisSelected = true;
  bool isPasswordValid = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    detectCountry();

    phoneController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
  }

  bool get isNextEnabled {
    if (isEmailisSelected) {
      return emailController.text.isNotEmpty && isPasswordValid;
    } else {
      return phoneController.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> detectCountry() async {
    await CountryCodes.init();
    final details = CountryCodes.detailsForLocale();

    setState(() {
      selectedCountry = Country(
        phoneCode: details.dialCode!.replaceAll('+', ''),
        countryCode: details.alpha2Code!,
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: details.name ?? '',
        example: '',
        displayName: details.name ?? '',
        displayNameNoCountryCode: details.name ?? '',
        e164Key: '',
      );
    });
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showSearch: true,
      useSafeArea: true,

      countryListTheme: CountryListThemeData(
        backgroundColor: const Color(0xff040406),

        textStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: const TextStyle(color: Colors.white54),

          prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 18),
          isDense: true,
          filled: true,
          fillColor: searchBarColor,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xff040406),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Enter phone or email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xff1e2023),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: isEmailisSelected
                            ? Alignment.centerRight
                            : Alignment.bottomLeft,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 28) / 2,
                          height: 36,
                          decoration: BoxDecoration(
                            color: uiColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                if (isEmailisSelected) {
                                  setState(() {
                                    isEmailisSelected = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                if (!isEmailisSelected) {
                                  setState(() {
                                    isEmailisSelected = true;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      IgnorePointer(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Phone",
                                  style: TextStyle(
                                    color: !isEmailisSelected
                                        ? Colors.white
                                        : Colors.white54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    color: isEmailisSelected
                                        ? Colors.white
                                        : Colors.white54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (isEmailisSelected) ...[
                  const Text("Email", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  InputField(hint: "Email", controller: emailController),

                  const SizedBox(height: 12),
                  Password(
                    onChanged: (valid) {
                      setState(() {
                        isPasswordValid = valid;
                      });
                    },
                  ),
                ] else ...[
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xff1e2023),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _openCountryPicker,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  selectedCountry == null
                                      ? "..."
                                      : "${selectedCountry!.countryCode} +${selectedCountry!.phoneCode}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(color: Colors.white24),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.green,
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isNextEnabled
                        ? () {
                            if (isEmailisSelected) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DisplayName(),
                                ),
                              );
                            } else {
                              final phone =
                                  "+${selectedCountry?.phoneCode}${phoneController.text}";
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtpPage(phoneNumber: phone),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: uiColor,
                      disabledBackgroundColor: uiColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
