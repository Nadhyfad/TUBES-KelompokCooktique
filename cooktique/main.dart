import 'package:flutter/material.dart';
// Import halaman create recipe yang berada di folder screens
import 'screens/create_recipe_menu_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi palet warna sesuai tema aplikasi Anda
    const Color primaryDark = Color(0xff3C2415);
    const Color bgColor = Color(0xffECE8E1);

    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        // Konfigurasi tema warna global
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryDark,
          primary: primaryDark,
          surface: bgColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryDark),
          titleTextStyle: TextStyle(
            color: primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        useMaterial3: true,
      ),
      // Mengarahkan halaman pertama kali terbuka ke menu pembuatan resep
      home: const CreateRecipeMenuScreen(),
    );
  }
}