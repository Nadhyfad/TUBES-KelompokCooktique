import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  bool _isResultEmpty = false;

  void _onSearchSubmitted(String query) {
    setState(() {
      _hasSearched = true;
      // Simulasi logika pencarian: Jika mencari "es podeng", alihkan ke tampilan kosong
      if (query.trim().toLowerCase() == 'es podeng') {
        _isResultEmpty = true;
      } else {
        _isResultEmpty = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button & Head Title
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                  const Text('Back', style: TextStyle(fontSize: 16)),
                ],
              ),
              const Text('Cooktique', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF321B11))),
              const SizedBox(height: 12),
              
              // Input Pencarian Aktif
              TextField(
                controller: _searchController,
                autofocus: true,
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: 'Search for recipes or accounts...',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _hasSearched = false;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              // Penentu Layout (Kondisi Kosong VS Ditemukan)
              Expanded(
                child: !_hasSearched
                    ? const Center(child: Text('Ketik resep dan tekan enter'))
                    : _isResultEmpty
                        ? _buildEmptyState()
                        : _buildRecipeResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAMPILAN JIKA RESEP TIDAK ADA (Gambar 8)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.brown[100],
            child: const Icon(Icons.search, size: 40, color: Color(0xFF321B11)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recipe not found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF321B11)),
          ),
        ],
      ),
    );
  }

  // TAMPILAN JIKA RESEP ADA (Gambar 7)
  Widget _buildRecipeResults() {
    return ListView(
      children: [
        const Text('Recipes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: [
            _buildGridCard('Pepes Ikan', '2h', '4.0'),
            _buildGridCard('Klepon Gula Jawa', '2h', '4.0'),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Signature Recipes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: [
            _buildGridCard('Ayam Geprek Mozz', '12m', '4.9'),
            _buildGridCard('Nasi Goreng Ikan', '20m', '4.8'),
          ],
        ),
      ],
    );
  }

  Widget _buildGridCard(String name, String duration, String rating) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          const Positioned.fill(child: Icon(Icons.fastfood, color: Colors.white24, size: 50)),
          Positioned(
            left: 8, top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
              child: const Text('Main Course', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
          Positioned(
            bottom: 8, left: 8, right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black)])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(duration, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Row(children: [const Icon(Icons.star, color: Colors.orange, size: 14), Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12))]),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}