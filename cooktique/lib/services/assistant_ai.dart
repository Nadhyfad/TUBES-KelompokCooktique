import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class AssistantAiService {
  // API Key Cooktique AI Gemini Anda
  final String _apiKey = "AQ.Ab8RN6LKgd7LiGDz-UNse00xWMx-DFmHyweAGl6oxwOB022Wzg";

  /// Fungsi untuk mengirim draf teks dan gambar langsung ke Google Gemini API
  Future<String> sendMessageToAi({required String text, File? imageFile}) async {
    try {
      final model = GenerativeModel(
        // 🛠️ DIUBAH KE MODEL TERBARU AGAR DIKENALI OLEH SERVER API GOOGLE
        model: 'gemini-2.5-flash', 
        apiKey: _apiKey,
      );

      String systemPrompt = "Kamu adalah Cooktique AI Cooking Assistant yang sangat ahli. "
          "Tugas utamamu adalah menganalisis bahan makanan yang difoto atau ditulis oleh user, "
          "lalu memberikan rekomendasi resep menu masakan yang lezat, kreatif, dan praktis beserta langkah-langkahnya. "
          "Gunakan bahasa Indonesia yang santun, ramah, dan mudah dipahami oleh pemula.\n\n"
          "Pertanyaan/Input User: $text";

      final List<Content> content = [];

      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();
        content.add(
          Content.multi([
            TextPart(systemPrompt),
            DataPart('image/jpeg', imageBytes),
          ]),
        );
      } else {
        content.add(Content.text(systemPrompt));
      }

      final response = await model.generateContent(content);
      return response.text ?? "Maaf, AI tidak memberikan respons.";
      
    } catch (e) {
      return "Koneksi Error: $e\n\nPastikan koneksi internet di HP/Emulator aktif.";
    }
  }
}