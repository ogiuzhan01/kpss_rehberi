import 'package:flutter/material.dart';

class GolModel {
  final String id;
  final String ad;
  final String bolge;
  final String tur;
  final double x;
  final double y;

  GolModel({
    required this.id,
    required this.ad,
    required this.bolge,
    required this.tur,
    required this.x,
    required this.y,
  });
}

class HaritaEtkinlikPage extends StatefulWidget {
  const HaritaEtkinlikPage({Key? key}) : super(key: key);

  @override
  State<HaritaEtkinlikPage> createState() => _HaritaEtkinlikPageState();
}

class _HaritaEtkinlikPageState extends State<HaritaEtkinlikPage> {
  String? secilenGolId;
  String secilenBolgeFiltresi = 'Tüm Bölgeler';
  final Map<String, bool> eslesenGoller = {};
  final TransformationController _transformationController = TransformationController();

  final List<GolModel> tumGoller = [
    // MARMARA BÖLGESİ
    GolModel(id: 'iznik', ad: 'İznik Gölü', bolge: 'Marmara', tur: 'Tektonik', x: 0.190, y: 0.280),
    GolModel(id: 'uluabat', ad: 'Uluabat Gölü', bolge: 'Marmara', tur: 'Tektonik', x: 0.135, y: 0.330),
    GolModel(id: 'manyas', ad: 'Manyas (Kuş) Gölü', bolge: 'Marmara', tur: 'Tektonik', x: 0.090, y: 0.330),
    GolModel(id: 'sapanca', ad: 'Sapanca Gölü', bolge: 'Marmara', tur: 'Tektonik', x: 0.220, y: 0.260),
    GolModel(id: 'terkos', ad: 'Terkos (Durusu)', bolge: 'Marmara', tur: 'Kıyı Set', x: 0.160, y: 0.080),
    GolModel(id: 'bcekmece', ad: 'Büyükçekmece', bolge: 'Marmara', tur: 'Kıyı Set', x: 0.130, y: 0.180),
    GolModel(id: 'kcekmece', ad: 'Küçükçekmece', bolge: 'Marmara', tur: 'Kıyı Set', x: 0.148, y: 0.190),

    // EGE BÖLGESİ
    GolModel(id: 'bafa', ad: 'Bafa (Çamiçi) Gölü', bolge: 'Ege', tur: 'Alüvyal Set', x: 0.075, y: 0.630),
    GolModel(id: 'marmara_golu', ad: 'Marmara Gölü', bolge: 'Ege', tur: 'Alüvyal Set', x: 0.095, y: 0.480),

    // AKDENİZ BÖLGESİ
    GolModel(id: 'egirdir', ad: 'Eğirdir Gölü', bolge: 'Akdeniz', tur: 'Tektonik/Karstik', x: 0.210, y: 0.600),
    GolModel(id: 'beysehir', ad: 'Beyşehir Gölü', bolge: 'Akdeniz', tur: 'Tektonik/Karstik', x: 0.245, y: 0.640),
    GolModel(id: 'burdur', ad: 'Burdur Gölü', bolge: 'Akdeniz', tur: 'Tektonik', x: 0.170, y: 0.620),
    GolModel(id: 'salda', ad: 'Salda Gölü', bolge: 'Akdeniz', tur: 'Karstik', x: 0.150, y: 0.630),
    GolModel(id: 'kovada', ad: 'Kovada Gölü', bolge: 'Akdeniz', tur: 'Karstik', x: 0.215, y: 0.650),
    GolModel(id: 'sufla', ad: 'Sufla (Suğla) Gölü', bolge: 'Akdeniz', tur: 'Karstik', x: 0.260, y: 0.690),
    GolModel(id: 'koycegiz', ad: 'Köyceğiz Gölü', bolge: 'Akdeniz', tur: 'Alüvyal Set', x: 0.100, y: 0.690),

    // İÇ ANADOLU BÖLGESİ
    GolModel(id: 'tuz', ad: 'Tuz Gölü', bolge: 'İç Anadolu', tur: 'Tektonik', x: 0.365, y: 0.490),
    GolModel(id: 'aksehir', ad: 'Akşehir Gölü', bolge: 'İç Anadolu', tur: 'Tektonik', x: 0.250, y: 0.540),
    GolModel(id: 'eber', ad: 'Eber Gölü', bolge: 'İç Anadolu', tur: 'Tektonik', x: 0.220, y: 0.520),
    GolModel(id: 'sefe', ad: 'Seyfe Gölü', bolge: 'İç Anadolu', tur: 'Tektonik', x: 0.390, y: 0.390),
    GolModel(id: 'mogan', ad: 'Mogan Gölü', bolge: 'İç Anadolu', tur: 'Alüvyal Set', x: 0.320, y: 0.330),
    GolModel(id: 'eymir', ad: 'Eymir Gölü', bolge: 'İç Anadolu', tur: 'Alüvyal Set', x: 0.325, y: 0.320),
    GolModel(id: 'meke', ad: 'Meke Maar Gölü', bolge: 'İç Anadolu', tur: 'Volkanik/Maar', x: 0.315, y: 0.610),

    // KARADENİZ BÖLGESİ
    GolModel(id: 'abant', ad: 'Abant Gölü', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.280, y: 0.210),
    GolModel(id: 'yedigoller', ad: 'Yedi Göller', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.295, y: 0.180),
    GolModel(id: 'zinav', ad: 'Zinav Gölü', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.530, y: 0.210),
    GolModel(id: 'tortum', ad: 'Tortum Gölü', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.720, y: 0.200),
    GolModel(id: 'sera', ad: 'Sera Gölü', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.640, y: 0.160),
    GolModel(id: 'borcka', ad: 'Borçka Karagöl', bolge: 'Karadeniz', tur: 'Heyelan Set', x: 0.760, y: 0.110),

    // DOĞU ANADOLU BÖLGESİ
    GolModel(id: 'van', ad: 'Van Gölü', bolge: 'Doğu Anadolu', tur: 'Karma (Volkanik Set)', x: 0.850, y: 0.460),
    GolModel(id: 'cildir', ad: 'Çıldır Gölü', bolge: 'Doğu Anadolu', tur: 'Volkanik Set', x: 0.865, y: 0.110),
    GolModel(id: 'ercek', ad: 'Erçek Gölü', bolge: 'Doğu Anadolu', tur: 'Volkanik Set', x: 0.890, y: 0.460),
    GolModel(id: 'nazik', ad: 'Nazik Gölü', bolge: 'Doğu Anadolu', tur: 'Volkanik Set', x: 0.800, y: 0.430),
    GolModel(id: 'nemrut', ad: 'Nemrut Gölü', bolge: 'Doğu Anadolu', tur: 'Krater Gölü', x: 0.805, y: 0.470),
    GolModel(id: 'hazar', ad: 'Hazar Gölü', bolge: 'Doğu Anadolu', tur: 'Tektonik', x: 0.610, y: 0.530),
    GolModel(id: 'balik', ad: 'Balık Gölü', bolge: 'Doğu Anadolu', tur: 'Volkanik Set', x: 0.880, y: 0.270),
  ];

  List<GolModel> getFiltrelenmisGoller() {
    if (secilenBolgeFiltresi == 'Tüm Bölgeler') {
      return tumGoller;
    }
    return tumGoller.where((gol) => gol.bolge == secilenBolgeFiltresi).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<GolModel> aktifGoller = getFiltrelenmisGoller();
    List<GolModel> kalanGoller = aktifGoller.where((g) => eslesenGoller[g.id] != true).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        title: const Text('Türkiye Göller Haritası', style: TextStyle(fontSize: 15, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: secilenBolgeFiltresi,
              dropdownColor: const Color(0xFF0F172A),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              icon: const Icon(Icons.filter_alt, color: Colors.white, size: 18),
              items: <String>[
                'Tüm Bölgeler',
                'Marmara',
                'Ege',
                'Akdeniz',
                'İç Anadolu',
                'Karadeniz',
                'Doğu Anadolu'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    secilenBolgeFiltresi = newValue;
                    secilenGolId = null;
                  });
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong, color: Colors.white, size: 20),
            tooltip: 'Yakınlaştırmayı Sıfırla',
            onPressed: () {
              _transformationController.value = Matrix4.identity();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                secilenGolId = null;
                eslesenGoller.clear();
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. HARİTA ALANI (InteractiveViewer ile Güvenli ve Kaymasız Alan)
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: _buildBigMapWidget(aktifGoller),
                ),
              ),
            ),

            // 2. ALT SEÇİM LİSTESİ (Sabit ve Tıklanabilir)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        secilenGolId == null ? 'Bir göl seçin:' : 'Haritadaki kırmızı noktaya dokunun',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: secilenGolId == null ? Colors.blueGrey : Colors.orange.shade900,
                        ),
                      ),
                      Text(
                        'Kalan: ${kalanGoller.length} / ${aktifGoller.length}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 44,
                    child: kalanGoller.isEmpty
                        ? const Center(
                            child: Text(
                              '🎉 Harika! Tüm gölleri eşleştirdiniz.',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: kalanGoller.length,
                            itemBuilder: (context, index) {
                              final gol = kalanGoller[index];
                              bool isSelected = secilenGolId == gol.id;

                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      secilenGolId = isSelected ? null : gol.id;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gol.ad,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Text(
                                          '${gol.tur} • ${gol.bolge}',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigMapWidget(List<GolModel> liste) {
    // Haritanın en-boy oranını sabitleyen LayoutBuilder ve AspectRatio yapısı
    return LayoutBuilder(
      builder: (context, constraints) {
        // Harita görselinin kusursuz en-boy oranı (Genişlik / Yükseklik)
        double aspectRatio = 1.6; 
        
        double width = constraints.maxWidth;
        double height = width / aspectRatio;

        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * aspectRatio;
        }

        double dotSize = 12.0;
        double touchSize = 32.0; // Noktalara parmakla rahat basılması için geniş alan

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/dilsiz_harita.png',
                    fit: BoxFit.fill,
                  ),
                ),
                ...liste.map((gol) {
                  bool isMatched = eslesenGoller[gol.id] == true;

                  // Doğru konumlandırma hesaplaması
                  double posX = (width * gol.x) - (touchSize / 2);
                  double posY = (height * gol.y) - (touchSize / 2);

                  return Positioned(
                    left: posX,
                    top: posY,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onPointTap(gol),
                      child: SizedBox(
                        width: touchSize,
                        height: touchSize,
                        child: Center(
                          child: Container(
                            width: dotSize,
                            height: dotSize,
                            decoration: BoxDecoration(
                              color: isMatched ? Colors.green.shade600 : Colors.red.shade600,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: isMatched
                                ? const Icon(Icons.check, color: Colors.white, size: 8)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPointTap(GolModel gol) {
    if (eslesenGoller[gol.id] == true) return;

    if (secilenGolId == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce aşağıdaki listeden bir göl seçin!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (secilenGolId == gol.id) {
      setState(() {
        eslesenGoller[gol.id] = true;
        secilenGolId = null;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tebrikler! ${gol.ad} doğru eşleşti.'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yanlış konum! Tekrar deneyin.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}