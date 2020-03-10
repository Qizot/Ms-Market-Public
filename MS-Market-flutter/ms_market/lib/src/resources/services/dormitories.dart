



import 'package:ms_market/src/models/dormitory.dart';

class DormitoriesService {

  static DormitoriesService _instance;

  final List<Dormitory> _dormitories;
  final Map<String, Dormitory> mapped;

factory DormitoriesService(){
    if (DormitoriesService._instance == null) {
      final dormitories = _rawDormitories.map((v) => Dormitory.fromJson(v)).toList();
      final mapped = Map<String, Dormitory>();

      dormitories.forEach((dorm) {
        mapped[dorm.name] = dorm;
      });
      DormitoriesService._instance = DormitoriesService._privateConstructor(dormitories: dormitories, mapped: mapped);
    }
    return DormitoriesService._instance;
  }

  DormitoriesService._privateConstructor({List<Dormitory> dormitories, this.mapped}): _dormitories = dormitories; 

  Dormitory findByName(String name) {
    return mapped[name];
  }


  static DormitoriesService get instance => _instance;

  List<Dormitory> get dormitories => _dormitories;
  List<String> get dormitoryNames => _dormitories.map((v) => v.name).toList();




  static List<dynamic> _rawDormitories = [
    {
        "index": 1,
        "name": "DS1",
        "fullname": "DS1 Olimp",
        "latitude":50.068961, 
        "longitude": 19.904286
    },
    {
        "index": 2,
        "name": "DS2",
        "fullname": "DS2 Babilon",
        "latitude": 50.069337, 
        "longitude": 19.904900
    },
    {
        "index": 3,
        "name": "DS3",
        "fullname": "DS3 Akropol",
        "latitude": 50.069606, 
        "longitude": 19.903114
    },
    {
        "index": 4,
        "name": "DS4",
        "fullname": "DS4 Filutek",
        "latitude": 50.0693162,
        "longitude": 19.9035392
    },
    {
        "index": 5,
        "name": "DS5",
        "fullname": "DS5 Strumyk",
        "latitude": 50.068958, 
        "longitude": 19.905597
    },
    {
        "index": 6,
        "name": "DS6",
        "fullname": "DS6 Bratek",
        "latitude": 50.068433, 
        "longitude": 19.905332
    },
    {
        "index": 7,
        "name": "DS7",
        "fullname": "DS7 Zaścianek",
        "latitude": 50.068016, 
        "longitude": 19.905151

    },
    {
        "index": 8,
        "name": "DS8",
        "fullname": "DS8 Stokrotka",
        "latitude": 50.067573, 
        "longitude": 19.905130
    },
    {
        "index": 9,
        "name": "DS9",
        "fullname": "DS9 Omega",
        "latitude": 50.069140, 
        "longitude": 19.906920
    },
    {
        "index": 10,
        "name": "DS10",
        "fullname": "DS10 Hajduczek",
        "latitude": 50.068654,
        "longitude": 19.906876
    },
    {
        "index": 11,
        "name": "DS11",
        "fullname": "DS11 Bonus",
        "latitude": 50.068269, 
        "longitude": 19.906711
    },
    {
        "index": 12,
        "name": "DS12",
        "fullname": "DS12 Promyk",
        "latitude": 50.067827,
        "longitude": 19.906191
    },
    {
        "index": 13,
        "name": "DS13",
        "fullname": "DS13 Straszny Dwór",
        "latitude": 50.067430,
        "longitude": 19.906199
    },
    {
        "index": 14,
        "name": "DS14",
        "fullname": "DS14 Kapitol",
        "latitude": 50.067752, 
        "longitude": 19.907149
    },
    {
        "index": 15,
        "name": "DS15",
        "fullname": "DS15 Maraton",
        "latitude": 50.068118,
        "longitude": 19.901596
    },
    {
        "index": 16,
        "name": "DS16",
        "fullname": "DS16 Itaka",
        "latitude": 50.068586,
        "longitude": 19.901949
    },
    {
        "index": 17,
        "name": "DS17",
        "fullname": "DS17 Arkadia",
        "latitude": 50.068941,
        "longitude": 19.902083
    },
    {
        "index": 18,
        "name": "DS18",
        "fullname": "DS18",
        "latitude": 50.069414,
        "longitude": 19.901871
    },
    {
        "index": 19,
        "name": "DS19",
        "fullname": "DS19",
        "latitude": 50.069796,
        "longitude": 19.902165
    },
    {
        "index": 20,
        "name": "ALFA",
        "fullname": "Alfa",
        "latitude": 50.065902, 
        "longitude": 19.915240
    }
  ];

}