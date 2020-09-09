import 'package:flutter/foundation.dart';
import 'package:ineed_flutter/models/NeedItem.dart';

class NeedProvider with ChangeNotifier {
  List<NeedItem> _needs = [];

  List<NeedItem> get needs => _needs;

  void setNeed(List<NeedItem> needs) {
    _needs = needs;
    notifyListeners();
  }
}
