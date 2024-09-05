import 'package:flutter/material.dart';

import '../models/entity_model.dart';

class CommonProvider extends ChangeNotifier {
  List<EntityModel> genders = [
    EntityModel(
      code: "M",
      description: "Male",
    ),
    EntityModel(
      code: "F",
      description: "Female",
    ),
  ];
}
