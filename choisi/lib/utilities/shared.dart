import 'package:shared_preferences/shared_preferences.dart';

class SharedApp {

  getStringValuesSF(String ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(ref);
    return stringValue;
  }
  getBoolValuesSF(String ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(ref);
    return boolValue;
  }
  getIntValuesSF(String ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(ref);
    return intValue;
  }
  getDoubleValuesSF(String ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(ref);
    return doubleValue;
  }

  initStringValue(String type, String key, var value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      switch (type) {
        case "string":
          prefs.setString(key, value);
          break;
        case "int" :
          prefs.setInt(key, value);
          break;
        case "double" :
          prefs.setDouble(key, value);
          break;
        case "bool" :
          prefs.setBool(key, value);
          break;
        case "list" :
          prefs.setStringList(key, value);
          break;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}