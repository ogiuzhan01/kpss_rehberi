import 'package:flutter/material.dart';

enum GolKategorisi {
  hepsi('Hepsi (Karma)'),
  tektonik('Tektonik Göller'),
  karstik('Karstik Göller'),
  heyelanSet('Heyelan Set Gölleri'),
  volkanikSet('Volkanik / Volkanik Set Gölleri'),
  kiyiSet('Kıyı Set (Lagün) Gölleri'),
  aluvyalSet('Alüvyal Set Gölleri');

  final String baslik;
  const GolKategorisi(this.baslik);
}

class GolModel {
  final String id;
  final String ad;
  final GolKategorisi kategori;
  final double x; // Dilsiz harita üzerindeki X oranı (0.0 - 1.0)
  final double y; // Dilsiz harita üzerindeki Y oranı (0.0 - 1.0)

  GolModel({
    required this.id,
    required this.ad,
    required this.kategori,
    required this.x,
    required this.y,
  });
}

class HaritaEtkinlikPage extends StatefulWidget {
  const HaritaEtkinlikPage({super.key});

  @override
  State<HaritaEtkinlikPage> createState() => _HaritaEtkinlikPageState();
}

class _HaritaEtkinlikPageState extends State<HaritaEtkinlikPage> {
  // KPSS Veritabanı: Göller ve Kategorileri
  final List<GolModel> _tumGoller = [
    // Tektonik
    GolModel(id: 'tuz', ad: 'Tuz Gölü', kategori: GolKategorisi.tektonik, x: 0.48, y: 0.53),
    GolModel(id: 'iznik', ad: 'İznik Gölü', kategori: GolKategorisi.tektonik, x: 0.28, y: 0.28),
    GolModel(id: 'sapanca', ad: 'Sapanca Gölü', kategori: GolKategorisi.tektonik, x: 0.31, y: 0.26),
    GolModel(id: 'uluabat', ad: 'Uluabat Gölü', kategori: GolKategorisi.tektonik, x: 0.25, y: 0.32),
    
    // Karstik
    GolModel(id: 'salda', ad: 'Salda Gölü', kategori: GolKategorisi.karstik, x: 0.31, y: 0.65),
    GolModel(id: 'avlan', ad: 'Avlan Gölü', kategori: GolKategorisi.karstik, x: 0.32, y: 0.72),

    // Heyelan Set
    GolModel(id: 'abant', ad: 'Abant Gölü', kategori: GolKategorisi.heyelanSet, x: 0.38, y: 0.26),
    GolModel(id: 'tortum', ad: 'Tortum Gölü', kategori: GolKategorisi.heyelanSet, x: 0.78, y: 0.28),
    GolModel(id: 'sera', ad: 'Sera Gölü', kategori: GolKategorisi.heyelanSet, x: 0.69, y: 0.22),

    // Volkanik / Karma
    GolModel(id: 'van', ad: 'Van Gölü', kategori: GolKategorisi.volkanikSet, x: 0.83, y: 0.48),
    GolModel(id: 'cildir', ad: 'Çıldır Gölü', kategori: GolKategorisi.volkanikSet, x: 0.85, y: 0.22),
    GolModel(id: 'nemrut', ad: 'Nemrut Gölü', kategori: GolKategorisi.volkanikSet, x: 0.80, y: 0.50),

    // Kıyı Set
    GolModel(id: 'bcekmece', ad: 'B. Çekmece', kategori: GolKategorisi.kiyiSet, x: 0.20, y: 0.23),
    GolModel(id: 'terkos', ad: 'Terkos (Durusu)', kategori: GolKategorisi.kiyiSet, x: 0.21, y: 0.19),

    // Alüvyal Set
    GolModel(id: 'mogan', ad: 'Mogan Gölü', kategori: GolKategorisi.aluvyalSet, x: 0.45, y: 0.41),
    GolModel(id: 'bafa', ad: 'Bafa (Çamiçi)', kategori: GolKategorisi.aluvyalSet, x: 0.20, y: 0.61),
  ];

  GolKategorisi _seciliKategori = GolKategorisi.hepsi;
  final Map<String, bool> _eslesenGoller = {};
  List<GolModel> _aktifGoller = [];
  List<GolModel> _kalanGoller = [];

  @override
  void initState() {
    super.initState();
    _kategoriDegistir(GolKategorisi.hepsi);
  }

  void _kategoriDegistir(GolKategorisi yeniKategori) {
    setState(() {
      _seciliKategori = yeniKategori;
      _eslesenGoller.clear();
      
      if (yeniKategori == GolKategorisi.hepsi) {
        _aktifGoller = List.from(_tumGoller);
      } else {
        _aktifGoller = _tumGoller.where((g) => g.kategori == yeniKategori).toList();
      }
      
      _kalanGoller = List.from(_aktifGoller)..shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dilsiz Harita: Göl Eşleştirme'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _kategoriDegistir(_seciliKategori),
            tooltip: 'Sıfırla',
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Kategori Seçim Menüsü (Dropdown/Filter)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.indigo.shade100,
            child: Row(
              children: [
                const Text('Kategori: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<GolKategorisi>(
                      value: _seciliKategori,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 14),
                      onChanged: (val) {
                        if (val != null) _kategoriDegistir(val);
                      },
                      items: GolKategorisi.values.map((kat) {
                        return DropdownMenuItem(
                          value: kat,
                          child: Text(kat.baslik),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Üst Skor Paneli
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skor: ${_eslesenGoller.length} / ${_aktifGoller.length}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                Text(
                  _eslesenGoller.length == _aktifGoller.length && _aktifGoller.isNotEmpty
                      ? '🎉 Tebrikler! Tüm gölleri buldun.'
                      : 'Sürükle ve Haritada Yerleştir!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _eslesenGoller.length == _aktifGoller.length ? Colors.green : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // 3. Dilsiz Harita Alanı
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 3.5,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 2.1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;

                      return Stack(
                        children: [
                          // Dilsiz Harita Görseli
                          Image.asset(
                            'assets/dilsiz_harita.png',
                            width: w,
                            height: h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: w,
                                height: h,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Text('dilsiz_harita.png Bulunamadı!'),
                                ),
                              );
                            },
                          ),

                          // Sadece Seçili Kategoriye Ait Hedef Noktalar
                          ..._aktifGoller.map((gol) {
                            final isMatched = _eslesenGoller[gol.id] ?? false;

                            return Positioned(
                              left: (gol.x * w) - 18,
                              top: (gol.y * h) - 18,
                              child: DragTarget<GolModel>(
                                onWillAcceptWithDetails: (details) => !isMatched,
                                onAcceptWithDetails: (details) {
                                  if (details.data.id == gol.id) {
                                    setState(() {
                                      _eslesenGoller[gol.id] = true;
                                      _kalanGoller.removeWhere((item) => item.id == gol.id);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Yanlış konum! Tekrar dene.'),
                                        duration: Duration(milliseconds: 600),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 250),
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isMatched
                                              ? Colors.teal.shade600
                                              : (candidateData.isNotEmpty
                                                  ? Colors.amber
                                                  : Colors.indigo.withOpacity(0.15)),
                                          border: Border.all(
                                            color: isMatched ? Colors.white : Colors.indigo.shade800,
                                            width: isMatched ? 2 : 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isMatched ? Icons.check : Icons.water_drop,
                                            size: 18,
                                            color: isMatched ? Colors.white : Colors.indigo.shade700,
                                          ),
                                        ),
                                      ),
                                      if (isMatched)
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.indigo.shade900,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            gol.ad,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // 4. Alt Sürüklenecek Göl Kartları
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: _kalanGoller.isEmpty
                ? const Center(
                    child: Text(
                      '👏 Kategori Tamamlandı!',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _kalanGoller.length,
                    itemBuilder: (context, index) {
                      final gol = _kalanGoller[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Draggable<GolModel>(
                          data: gol,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.water_drop, color: Colors.cyanAccent, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    gol.ad,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildChip(gol.ad),
                          ),
                          child: _buildChip(gol.ad),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String ad) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Colors.cyanAccent, size: 16),
          const SizedBox(width: 6),
          Text(
            ad,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}