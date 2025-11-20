//
// class BDInfo {
//   // ৮টি বিভাগ
//   static const List<String> divisions = [
//     "ঢাকা", "চট্টগ্রাম", "রাজশাহী", "খুলনা",
//     "বরিশাল", "সিলেট", "রংপুর", "ময়মনসিংহ"
//   ];
//
//   // জেলা (বিভাগ অনুযায়ী)
//   static List<String> getDistrictsByDivision(String division) {
//     final Map<String, List<String>> data = {
//       "ঢাকা": ["ঢাকা", "গাজীপুর", "নারায়ণগঞ্জ", "টাঙ্গাইল", "কিশোরগঞ্জ"],
//       "চট্টগ্রাম": ["চট্টগ্রাম", "কক্সবাজার", "রাঙামাটি", "বান্দরবান",'Lakshmipur','Feni',"Chadpur","Nowakhali"],  //'Lakshmipur','Feni',"Chadpur","Nowakhali"
//       "রাজশাহী": ["রাজশাহী", "বগুড়া", "পাবনা", "নাটোর"],
//       "খুলনা": ["খুলনা", "যশোর", "সাতক্ষীরা", "বাগেরহাট"],
//       "বরিশাল": ["বরিশাল", "পটুয়াখালী", "ভোলা"],
//       "সিলেট": ["সিলেট", "মৌলভীবাজার", "হবিগঞ্জ"],
//       "রংপুর": ["রংপুর", "দিনাজপুর", "কুড়িগ্রাম"],
//       "ময়মনসিংহ": ["ময়মনসিংহ", "জামালপুর", "নেত্রকোণা"],
//     };
//     return data[division] ?? [];
//   }
//
//   // উপজেলা (জেলা অনুযায়ী)
//   static List<String> getUpazilasByDistrict(String district) {
//     final Map<String, List<String>> data = {
//       "ঢাকা": ["মিরপুর", "গুলশান", "উত্তরা", "ধানমন্ডি"],
//       "গাজীপুর": ["টঙ্গী", "কালিয়াকৈর", "শ্রীপুর"],
//       "চট্টগ্রাম": ["হালিশহর", "পাঁচলাইশ", "কর্ণফুলী"],
//       "কক্সবাজার": ["কক্সবাজার সদর", "উখিয়া", "টেকনাফ"],
//       "Lakshmipur": ["Raipur", "Ramgonj", "Ramgoti","Chondogonj"],
//       // আরো চাইলে যোগ করো
//     };
//     return data[district] ?? ["${district} সদর"];
//   }
// }

class BDInfo {
  // ৮টি বিভাগ
  static const List<String> divisions = [
    "Dhaka", "Chattogram", "Rajshahi", "Khulna",
    "Barishal", "Sylhet", "Rangpur", "Mymensingh"
  ];

  // জেলা (বিভাগ অনুযায়ী)
  static List<String> getDistrictsByDivision(String division) {
    final Map<String, List<String>> data = {
      "Dhaka": [
        "Dhaka", "Faridpur", "Gazipur", "Gopalganj", "Kishoreganj",
        "Madaripur", "Manikganj", "Munshiganj", "Narayanganj",
        "Narsingdi", "Rajbari", "Shariatpur", "Tangail"
      ],
      "Chattogram": [
        "Bandarban", "Brahmanbaria", "Chandpur", "Chattogram",
        "Cox's Bazar", "Cumilla", "Feni", "Khagrachhari",
        "Lakshmipur", "Noakhali", "Rangamati"
      ],
      "Rajshahi": [
        "Bogura", "Joypurhat", "Naogaon", "Natore",
        "Chapainawabganj", "Pabna", "Rajshahi", "Sirajganj"
      ],
      "Khulna": [
        "Bagerhat", "Chuadanga", "Jashore", "Jhenaidah",
        "Khulna", "Kushtia", "Magura", "Meherpur",
        "Narail", "Satkhira"
      ],
      "Barishal": [
        "Barguna", "Barishal", "Bhola", "Jhalokathi",
        "Patuakhali", "Pirojpur"
      ],
      "Sylhet": [
        "Habiganj", "Moulvibazar", "Sunamganj", "Sylhet"
      ],
      "Rangpur": [
        "Dinajpur", "Gaibandha", "Kurigram", "Lalmonirhat",
        "Nilphamari", "Panchagarh", "Rangpur", "Thakurgaon"
      ],
      "Mymensingh": [
        "Jamalpur", "Mymensingh", "Netrokona", "Sherpur"
      ],
    };
    return data[division] ?? [];
  }

  // উপজেলা (জেলা অনুযায়ী)
  static List<String> getUpazilasByDistrict(String district) {
    final Map<String, List<String>> data = {
      // ---------- DHAKA DIVISION ----------
      "Dhaka": ["Dhamrai", "Dohar", "Keraniganj", "Nawabganj", "Savar"],
      "Faridpur": ["Alfadanga", "Bhanga", "Boalmari", "Char Bhadrasan", "Faridpur Sadar", "Madhukhali", "Nagarkanda", "Sadarpur", "Saltha"],
      "Gazipur": ["Gazipur Sadar", "Kaliakoir", "Kaliganj", "Kapasia", "Sreepur"],
      "Gopalganj": ["Gopalganj Sadar", "Kashiani", "Kotalipara", "Muksudpur", "Tungipara"],
      "Kishoreganj": [
        "Austagram", "Bajitpur", "Bhairab", "Hossainpur", "Itna",
        "Karimganj", "Katiadi", "Kishoreganj Sadar", "Kuliarchar",
        "Mithamain", "Nikli", "Pakundia", "Tarail"
      ],
      "Madaripur": ["Kalkini", "Madaripur Sadar", "Rajoir", "Shibchar"],
      "Manikganj": ["Daulatpur", "Ghior", "Harirampur", "Manikganj Sadar", "Saturia", "Shibalaya", "Singair"],
      "Munshiganj": ["Gazaria", "Lohajang", "Munshiganj Sadar", "Sirajdikhan", "Sreenagar", "Tongibari"],
      "Narayanganj": ["Araihazar", "Bandar", "Narayanganj Sadar", "Rupganj", "Sonargaon"],
      "Narsingdi": ["Belabo", "Monohardi", "Narsingdi Sadar", "Palash", "Raipura", "Shibpur"],
      "Rajbari": ["Baliakandi", "Goalandaghat", "Kalukhali", "Pangsha", "Rajbari Sadar"],
      "Shariatpur": ["Bhedarganj", "Damudya", "Gosairhat", "Naria", "Shariatpur Sadar", "Zanjira"],
      "Tangail": [
        "Basail", "Bhuapur", "Delduar", "Dhanbari", "Ghatail", "Gopalpur",
        "Kalihati", "Madhupur", "Mirzapur", "Nagarpur", "Sakhipur", "Tangail Sadar"
      ],

      // ---------- CHATTOGRAM DIVISION ----------
      "Bandarban": ["Alikadam", "Bandarban Sadar", "Lama", "Naikhongchhari", "Rowangchhari", "Ruma", "Thanchi"],
      "Brahmanbaria": ["Akhaura", "Bancharampur", "Bijoynagar", "Brahmanbaria Sadar", "Kasba", "Nabinagar", "Nasirnagar", "Sarail"],
      "Chandpur": ["Chandpur Sadar", "Faridganj", "Haimchar", "Hajiganj", "Kachua", "Matlab Dakshin", "Matlab Uttar", "Shahrasti"],
      "Chattogram": [
        "Anwara", "Banshkhali", "Boalkhali", "Chandanaish", "Fatikchhari",
        "Hathazari", "Lohagara", "Mirsharai", "Patiya", "Rangunia",
        "Raozan", "Sandwip", "Satkania", "Sitakunda"
      ],
      "Cox's Bazar": ["Chakaria", "Cox's Bazar Sadar", "Kutubdia", "Maheshkhali", "Pekua", "Ramu", "Teknaf", "Ukhiya"],
      "Cumilla": [
        "Barura", "Brahmanpara", "Burichong", "Chandina", "Chauddagram",
        "Cumilla Adarsha Sadar", "Cumilla Sadar Dakshin", "Daudkandi",
        "Debidwar", "Homna", "Laksam", "Lalmai", "Manoharganj",
        "Meghna", "Muradnagar", "Nangalkot", "Titas"
      ],
      "Feni": ["Chhagalnaiya", "Daganbhuiyan", "Feni Sadar", "Parshuram", "Phulgazi", "Sonagazi"],
      "Khagrachhari": ["Dighinala", "Khagrachhari Sadar", "Lakshmichhari", "Mahalchhari", "Manikchhari", "Matiranga", "Panchhari", "Ramgarh"],
      "Lakshmipur": ["Lakshmipur Sadar", "Raipur", "Ramganj", "Ramgati", "Kamalnagar"],
      "Noakhali": ["Begumganj", "Chatkhil", "Companiganj", "Hatiya", "Kabirhat", "Noakhali Sadar", "Senbagh", "Sonaimuri", "Subarnachar"],
      "Rangamati": [
        "Baghaichhari", "Barkal", "Belaichhari", "Juraichhari", "Kaptai",
        "Kawkhali", "Langadu", "Naniarchar", "Rajasthali", "Rangamati Sadar"
      ],

      // ---------- RAJSHAHI ----------
      "Bogura": ["Adamdighi", "Bogura Sadar", "Dhunat", "Dhupchanchia", "Gabtali", "Kahalu", "Nandigram", "Sariakandi", "Shahjahanpur", "Sherpur", "Shibganj", "Sonatala"],
      "Joypurhat": ["Akkelpur", "Joypurhat Sadar", "Kalai", "Khetlal", "Panchbibi"],
      "Naogaon": ["Atrai", "Badalgachhi", "Dhamoirhat", "Manda", "Mahadebpur", "Naogaon Sadar", "Niamatpur", "Patnitala", "Porsha", "Raninagar", "Sapahar"],
      "Natore": ["Bagatipara", "Baraigram", "Gurudaspur", "Lalpur", "Naldanga", "Natore Sadar", "Singra"],
      "Chapainawabganj": ["Bholahat", "Gomastapur", "Nachole", "Nawabganj Sadar", "Shibganj"],
      "Pabna": ["Atgharia", "Bera", "Bhangura", "Chatmohar", "Faridpur", "Ishwardi", "Pabna Sadar", "Santhia", "Sujanagar"],
      "Rajshahi": ["Bagha", "Bagmara", "Charghat", "Durgapur", "Godagari", "Mohanpur", "Paba", "Puthia", "Tanore"],
      "Sirajganj": ["Belkuchi", "Chauhali", "Kamarkhanda", "Kazipur", "Raiganj", "Shahjadpur", "Sirajganj Sadar", "Tarash", "Ullahpara"],

      // ---------- KHULNA ----------
      "Bagerhat": ["Bagerhat Sadar", "Chitalmari", "Fakirhat", "Kachua", "Mollahat", "Mongla", "Morrelganj", "Rampal", "Sarankhola"],
      "Chuadanga": ["Alamdanga", "Chuadanga Sadar", "Damurhuda", "Jibannagar"],
      "Jashore": ["Abhaynagar", "Bagherpara", "Chaugachha", "Jhikargachha", "Keshabpur", "Manirampur", "Sharsha", "Jashore Sadar"],
      "Jhenaidah": ["Harinakunda", "Jhenaidah Sadar", "Kaliganj", "Kotchandpur", "Maheshpur", "Shailkupa"],
      "Khulna": ["Batiaghata", "Dacope", "Dighalia", "Dumuria", "Koyra", "Paikgacha", "Phultala", "Rupsha", "Terokhada"],
      "Kushtia": ["Bheramara", "Daulatpur", "Khoksa", "Kumarkhali", "Kushtia Sadar", "Mirpur"],
      "Magura": ["Magura Sadar", "Mohammadpur", "Shalikha", "Sreepur"],
      "Meherpur": ["Gangni", "Meherpur Sadar", "Mujibnagar"],
      "Narail": ["Kalia", "Lohagara", "Narail Sadar"],
      "Satkhira": ["Assasuni", "Debhata", "Kalaroa", "Kaliganj", "Satkhira Sadar", "Shyamnagar", "Tala"],

      // ---------- BARISHAL ----------
      "Barguna": ["Amtali", "Bamna", "Barguna Sadar", "Betagi", "Patharghata", "Taltali"],
      "Barishal": ["Agailjhara", "Babuganj", "Bakerganj", "Banaripara", "Gaurnadi", "Hizla", "Barishal Sadar", "Mehendiganj", "Muladi", "Wazirpur"],
      "Bhola": ["Bhola Sadar", "Borhanuddin", "Char Fasson", "Daulatkhan", "Lalmohan", "Manpura", "Tazumuddin"],
      "Jhalokathi": ["Jhalokathi Sadar", "Kathalia", "Nalchity", "Rajapur"],
      "Patuakhali": ["Bauphal", "Dashmina", "Dumki", "Galachipa", "Kalapara", "Mirzaganj", "Patuakhali Sadar", "Rangabali"],
      "Pirojpur": ["Bhandaria", "Kawkhali", "Mathbaria", "Nazirpur", "Nesarabad", "Pirojpur Sadar", "Zianagar"],

      // ---------- SYLHET ----------
      "Habiganj": ["Ajmiriganj", "Bahubal", "Baniachang", "Chunarughat", "Habiganj Sadar", "Lakhai", "Madhabpur", "Nabiganj", "Shayestaganj"],
      "Moulvibazar": ["Barlekha", "Juri", "Kamalganj", "Kulaura", "Moulvibazar Sadar", "Rajnagar", "Sreemangal"],
      "Sunamganj": ["Bishwamvarpur", "Chatak", "Dakshin Sunamganj", "Derai", "Dharmapasha", "Dowarabazar", "Jagannathpur", "Jamalganj", "Sullah", "Sunamganj Sadar", "Tahirpur"],
      "Sylhet": [
        "Balaganj", "Beanibazar", "Bishwanath", "Companiganj", "Dakshin Surma",
        "Fenchuganj", "Golapganj", "Gowainghat", "Jaintiapur", "Kanaighat",
        "Osmaninagar", "Sylhet Sadar", "Zakiganj"
      ],

      // ---------- RANGPUR ----------
      "Dinajpur": ["Birampur", "Birganj", "Birol", "Bochaganj", "Chirirbandar", "Dinajpur Sadar", "Ghoraghat", "Hakimpur", "Kaharole", "Khansama", "Nawabganj", "Parbatipur"],
      "Gaibandha": ["Fulchhari", "Gaibandha Sadar", "Gobindaganj", "Palashbari", "Sadullapur", "Sughatta", "Sundarganj"],
      "Kurigram": ["Bhurungamari", "Char Rajibpur", "Chilmari", "Kurigram Sadar", "Nageshwari", "Phulbari", "Rajarhat", "Raomari", "Ulipur"],
      "Lalmonirhat": ["Aditmari", "Hatibandha", "Kaliganj", "Lalmonirhat Sadar", "Patgram"],
      "Nilphamari": ["Dimla", "Domar", "Jaldhaka", "Kishoreganj", "Nilphamari Sadar", "Saidpur"],
      "Panchagarh": ["Atwari", "Boda", "Debiganj", "Panchagarh Sadar", "Tetulia"],
      "Rangpur": ["Badarganj", "Gangachara", "Kaunia", "Mithapukur", "Pirgachha", "Pirganj", "Rangpur Sadar", "Taraganj"],
      "Thakurgaon": ["Baliadangi", "Haripur", "Pirganj", "Ranisankail", "Thakurgaon Sadar"],

      // ---------- MYMENSINGH ----------
      "Jamalpur": ["Baksiganj", "Dewanganj", "Islampur", "Jamalpur Sadar", "Madarganj", "Melandaha", "Sarishabari"],
      "Mymensingh": ["Bhaluka", "Dhobaura", "Fulbaria", "Gaffargaon", "Gauripur", "Haluaghat", "Ishwarganj", "Mymensingh Sadar", "Muktagachha", "Nandail", "Phulpur", "Tarakanda", "Trishal"],
      "Netrokona": ["Atpara", "Barhatta", "Durgapur", "Kalmakanda", "Kendua", "Khaliajuri", "Madan", "Mohanganj", "Netrokona Sadar", "Purbadhala"],
      "Sherpur": ["Jhenaigati", "Nakla", "Nalitabari", "Sherpur Sadar", "Sreebardi"],
    };

    return data[district] ?? ["${district} Sadar"];
  }
}
