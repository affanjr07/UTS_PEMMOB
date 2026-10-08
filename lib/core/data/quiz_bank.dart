import '../../models/question.dart';

/// Bank soal dummy (tanpa database, cukup lokal).
class QuizBank {
  QuizBank._();

  static const List<Question> questions = [
    Question(
      text: 'Tari Saman yang dikenal dengan gerakan serempak berasal dari daerah mana?',
      options: [
        'Nusa Tenggara Timur',
        'Aceh',
        'Sumatera Utara',
        'Kalimantan Barat',
      ],
      correctIndex: 1,
      category: QuizCategory.budaya,
      explanation: 'Tari Saman berasal dari suku Gayo, Aceh. Masuk dalam Warisan Budaya Takbenda UNESCO pada tahun 2011.',
    ),
    Question(
      text: 'Kapan teks Proklamasi Kemerdekaan Indonesia dibacakan?',
      options: [
        '17 Agustus 1945',
        '17 Agustus 1944',
        '10 November 1945',
        '1 Juni 1945',
      ],
      correctIndex: 0,
      category: QuizCategory.sejarah,
      explanation: 'Proklamasi dibacakan oleh Ir. Soekarno pada 17 Agustus 1945 di Jalan Pegangsaan Timur No. 56, Jakarta.',
    ),
    Question(
      text: 'Dalam sistem satuan SI, besaran fisika "gaya" memakai satuan bernama...',
      options: ['Joule', 'Watt', 'Newton', 'Pascal'],
      correctIndex: 2,
      category: QuizCategory.sains,
      explanation:
          'Gaya diukur dalam Newton (N), dinamai dari Sir Isaac Newton.',
    ),
    Question(
      text: 'Kepanjangan dari singkatan HTML adalah...',
      options: [
        'HyperText Markup Language',
        'HighTech Modern Language',
        'Home Tool Markup Language',
        'Hyperlink Text Machine Language',
      ],
      correctIndex: 0,
      category: QuizCategory.teknologi,
      explanation: 'HTML (HyperText Markup Language) adalah standar penanda konten dasar halaman web.',
    ),
    Question(
      text: 'Sungai terpanjang di Indonesia berada di pulau...',
      options: ['Sumatera', 'Kalimantan', 'Jawa', 'Sulawesi'],
      correctIndex: 1,
      category: QuizCategory.geografi,
      explanation: 'Sungai Kapuas di Kalimantan Barat berpanjang ±1.143 km, terpanjang di Indonesia.',
    ),
    Question(
      text: 'Alat musik bambu yang dimainkan dengan cara digoyang berasal dari...',
      options: ['Jawa Barat', 'Bali', 'Maluku', 'Papua'],
      correctIndex: 0,
      category: QuizCategory.budaya,
      explanation: 'Angklung berasal dari Jawa Barat dan tercatat sebagai Warisan Budaya Takbenda UNESCO tahun 2010.',
    ),
    Question(
      text: 'Planet mana yang memiliki ukuran terbesar di tata surya?',
      options: ['Saturnus', 'Bumi', 'Jupiter', 'Neptunus'],
      correctIndex: 2,
      category: QuizCategory.sains,
      explanation: 'Jupiter adalah planet terbesar; diameter sekitar 11 kali diameter Bumi.',
    ),
    Question(
      text: 'Framework lintas platform untuk membangun aplikasi mobile bernama Flutter dibuat oleh...',
      options: ['Apple', 'Meta', 'Google', 'Microsoft'],
      correctIndex: 2,
      category: QuizCategory.teknologi,
      explanation: 'Flutter dikembangkan Google dan dirilis pertama kali pada tahun 2017.',
    ),
    Question(
      text: 'Kompleks percandian yang menjadi pusat kerajaan Majapahit berada di daerah...',
      options: [
        'Trowulan, Jawa Timur',
        'Dieng, Jawa Tengah',
        'Bedulu, Bali',
        'Muarojambi, Jambi',
      ],
      correctIndex: 0,
      category: QuizCategory.sejarah,
      explanation: 'Trowulan adalah ibu kota Majapahit, kini menjadi kawasan arkeologi di Mojokerto, Jawa Timur.',
    ),
    Question(
      text: 'Puncak tertinggi di Indonesia terletak di...',
      options: [
        'Gunung Kerinci',
        'Puncak Jaya',
        'Gunung Semeru',
        'Gunung Rinjani',
      ],
      correctIndex: 1,
      category: QuizCategory.geografi,
      explanation: 'Puncak Jaya (Carstensz Pyramid) di Papua memiliki ketinggian sekitar 4.884 mdpl.',
    ),
    Question(
      text: 'Rumus kimia H2O merujuk pada senyawa...',
      options: ['Hidrogen peroksida', 'Air', 'Asam klorida', 'Metana'],
      correctIndex: 1,
      category: QuizCategory.sains,
      explanation: 'Satu molekul air terdiri dari dua atom hidrogen dan satu atom oksigen.',
    ),
    Question(
      text: 'Berapa jumlah bit dalam satu byte?',
      options: ['4 bit', '8 bit', '16 bit', '32 bit'],
      correctIndex: 1,
      category: QuizCategory.teknologi,
      explanation: 'Standar biner menetapkan 1 byte = 8 bit.',
    ),
  ];
}
