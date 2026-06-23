import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cooktique/services/assistant_ai.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.imagePath,
  });
}

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _requestController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final AssistantAiService _aiService = AssistantAiService();
  String? _selectedImageDraft;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! im your assistant",
      isUser: false,
      time: "10:54 AM",
    ),
  ];

  // 🛠️ REVISI FUNGSI: Mengambil Gambar + Memastikan Pemicu Izin Kamera Aktif
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Kompres gambar ke 80% agar upload ke AI super cepat
        maxWidth: 1080, // Membatasi resolusi lebar maksimal
        maxHeight: 1080, // Membatasi resolusi tinggi maksimal
      );

      if (image != null) {
        setState(() {
          _selectedImageDraft = image.path;
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil gambar atau izin ditolak: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Gagal mengakses kamera/galeri. Silakan periksa izin aplikasi di Pengaturan HP Anda.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // WIDGET: Memunculkan Pilihan Kamera atau Galeri dari Bawah
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Pilih Sumber Foto",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C2415),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFF9E8E84),
                ),
                title: const Text("Kamera (Ambil Foto Direct)"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera); // Pemicu Kamera
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.image_rounded,
                  color: Color(0xFF9E8E84),
                ),
                title: const Text("Galeri (Pilih Foto)"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery); // Pemicu Galeri
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _clearImageDraft() {
    setState(() {
      _selectedImageDraft = null;
    });
  }

  void _sendRequest() async {
    final text = _requestController.text.trim();

    if (text.isNotEmpty || _selectedImageDraft != null) {
      final String? finalImage = _selectedImageDraft;

      setState(() {
        _messages.add(
          ChatMessage(
            text: text,
            isUser: true,
            time: "10:55 AM",
            imagePath: finalImage,
          ),
        );

        _messages.add(
          ChatMessage(
            text: "Sedang memikirkan resep terbaik untukmu... 🍳⏳",
            isUser: false,
            time: "10:55 AM",
          ),
        );

        _requestController.clear();
        _selectedImageDraft = null;
      });

      _scrollToBottom();

      final aiResponse = await _aiService.sendMessageToAi(
        text: text,
        imageFile: finalImage != null ? File(finalImage) : null,
      );

      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(text: aiResponse, isUser: false, time: "10:56 AM"),
        );
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Container(height: 1, color: const Color(0x3FAEAEAE)),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    _buildChatBubble(_messages[index]),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedImageDraft != null) _buildImageDraftPreview(),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _requestController,
                                  decoration: const InputDecoration(
                                    hintText: 'Type your request...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF939393),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFFB0B0B0),
                                ),
                                onPressed: _showImageSourceBottomSheet,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _sendRequest,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF9E8E84),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isKeyboardOpen) ...[
                    const SizedBox(height: 16),
                    _buildNavigationTabs(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDraftPreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_selectedImageDraft!),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: _clearImageDraft,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: message.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.imagePath != null) ...[
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(message.imagePath!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (message.text.isNotEmpty) const SizedBox(height: 8),
                      ],
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: const TextStyle(
                            color: Color(0xFF2C2C2C),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF3C2415),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ai Assistant',
                style: TextStyle(
                  color: Color(0xFF3C2415),
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Keep track of your ingredients',
                style: TextStyle(color: Color(0xFF6C6F7F), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.home_outlined, 'Home'),
        _buildNavItem(Icons.layers_outlined, 'Pantry'),
        _buildCenterNavItem(),
        _buildNavItem(Icons.add_box_outlined, 'Create'),
        _buildNavItem(Icons.person_outline, 'Profile'),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF6A7282), size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6A7282), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCenterNavItem() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 26),
    );
  }
}
