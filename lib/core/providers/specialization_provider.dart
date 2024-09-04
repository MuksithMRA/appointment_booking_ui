import 'package:flutter/material.dart';

import '../models/specialization.dart';

class SpecializationProvider  extends ChangeNotifier{
  List<Specialization> specializations = [
    Specialization(id: 1, code: "card", description: "Cardiology"),
    Specialization(id: 2, code: "neur", description: "Neurology"),
    Specialization(id: 3, code: "derm", description: "Dermatology"),
  ];
}