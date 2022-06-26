// import "FirestoreQueryObjects.dart";
import 'package:womens_courtyard/personal_file.dart';

/// Here is concentrated the logic behind the queries sent to the database in
/// order to extract the proper data the user needs.
/// The queries are split into two types - Nationality induced statistics,
/// and attendance related one.

const Map<int, String> WEEKDAYS = <int, String>{
  1: 'שני',
  2: 'שלישי',
  3: 'רביעי',
  4: 'חמישי',
  5: 'שישי',
  6: 'שבת',
  7: 'ראשון',
};

Map<String, int> makeNationalitiesHist(List<PersonalFile> pfList) {
  var nationalitiesHist = Map<String, int>();
  print("starting to generate nationalities");
  pfList.map<String>((pf) => pf.nationality).forEach((nationality) {
    // if(!nationalitiesHist.containsKey(nationality)) {
    //   nationalitiesHist[nationality] = 1;
    // } else {
    //   nationalitiesHist['a'] += 1;
    //   (nationalitiesHist[nationality])! += 1;
    // }
    nationalitiesHist[nationality] = (nationalitiesHist[nationality] ?? 0) + 1;
  });
  print(
      "nationalities: $nationalitiesHist, type: ${nationalitiesHist.runtimeType}");
  return nationalitiesHist;
}

Map<String, int> makeVisitsHist(List<PersonalFile> pfList) {
  var visitsHist = Map<String, int>();
  WEEKDAYS.entries.forEach((dayMap) {
    visitsHist[dayMap.value] = 0;
  });
  print("finished initializing maps");
  pfList.forEach((pf) {
    pf.attendances.forEach((att) {
      print("DEBUG: date: ${att.date}, weekday number: ${att.date.weekday}");
      visitsHist[WEEKDAYS[att.date.weekday]!] =
          (visitsHist[WEEKDAYS[att.date.weekday]!] ?? 0) + 1;
    });
  });
  return visitsHist;
}
