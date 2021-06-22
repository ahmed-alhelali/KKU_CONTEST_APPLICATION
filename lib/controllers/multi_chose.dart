import 'package:kku_contest_app/imports.dart';

class MultipleNotifier extends ChangeNotifier {
  List<String> _selectedItems;

  MultipleNotifier(this._selectedItems);

  List<String> get selectedItems => _selectedItems;

  bool isHaveItem(String value) => _selectedItems.contains(value);

  addItem(String value) {
    if (!isHaveItem(value)) {
      _selectedItems.add(value);
      notifyListeners();
    }
  }

  removeItem(String value) {
    if (isHaveItem(value)) {
      _selectedItems.remove(value);
      notifyListeners();
    }
  }
}
