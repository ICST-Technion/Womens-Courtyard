// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:womens_courtyard/Attendance_page.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/StatisticsLogic.dart';

List<PersonalFile> all_files = [];

class MockAttendancePoster extends Mock implements AttendancePoster {
  String desClientkey;

  void desClientkeySetup(String ck, String l) {
    this.desClientkey = ck;

    all_files.add(PersonalFile(
      key: ck,
      firstName: "fname",
      lastName: "lname",
      idNo: "111111111",
      age: 2,
      address: "nowhere",
      phoneNo: "0500000000",
      nationality: l,
      clientNotes: [],
      inAssignment: false,
      processes: [],
      appointments: [],
      attendances: [],
      contactKeys: [],
    ));
  }

  @override
  void postAttendance(DateTime currDate, String dailySentence) async {
    int index = this.peronalIndex();
    Attendance attendance = Attendance(date: currDate, comment: dailySentence);
    if (index == -1) {
      throw new Exception("what?");
    } else {
      all_files[index].attendances.add(attendance);
    }
  }

  int peronalIndex() {
    for (int i = 0; i < all_files.length; i++) {
      if (all_files[i].key == this.desClientkey) {
        return i;
      }
    }
    return -1;
  }
}

void main() {
  MockAttendancePoster mockatt = MockAttendancePoster();

  setUp(() {
    all_files.clear();
  });
  tearDown(() {
    all_files.clear();
  });

  test("test statistics attendance initial", () async {
    Map<String, int> res = makeVisitsHist(all_files);
    expect(res["ראשון"], 0);
    expect(res["שני"], 0);
    expect(res["שלישי"], 0);
    expect(res["רביעי"], 0);
    expect(res["חמישי"], 0);
    expect(res["שישי"], 0);
    expect(res["שבת"], 0);
  });
  test("test statistics attendance insertion simple", () async {
    Map<String, int> res_prev = makeVisitsHist(all_files);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    mockatt.postAttendance(DateTime.parse('2022-06-28 20:18:04Z'), "hello");
    Map<String, int> res_after = makeVisitsHist(all_files);
    expect(res_prev["שלישי"], res_after["שלישי"] - 1);
    expect(res_prev["ראשון"], res_after["ראשון"]);
    expect(res_prev["שני"], res_after["שני"]);
    expect(res_prev["רביעי"], res_after["רביעי"]);
    expect(res_prev["חמישי"], res_after["חמישי"]);
    expect(res_prev["שישי"], res_after["שישי"]);
    expect(res_prev["שבת"], res_after["שבת"]);
  });
  test("test statistics attendance insertion midnight", () async {
    Map<String, int> res_prev = makeVisitsHist(all_files);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    mockatt.postAttendance(DateTime.parse('2022-06-28 00:00:00Z'), "hello");
    Map<String, int> res_after = makeVisitsHist(all_files);
    expect(res_prev["שלישי"], res_after["שלישי"] - 1);
    expect(res_prev["ראשון"], res_after["ראשון"]);
    expect(res_prev["שני"], res_after["שני"]);
    expect(res_prev["רביעי"], res_after["רביעי"]);
    expect(res_prev["חמישי"], res_after["חמישי"]);
    expect(res_prev["שישי"], res_after["שישי"]);
    expect(res_prev["שבת"], res_after["שבת"]);
  });
  test(
      "test statistics attendance insertion multiple clients single insertions",
      () async {
    Map<String, int> res_prev = makeVisitsHist(all_files);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    mockatt.postAttendance(DateTime.parse('2022-06-28 20:18:04Z'), "hello");
    mockatt.desClientkeySetup("client2", "אוכלוסיה ערבית");
    mockatt.postAttendance(DateTime.parse('2022-06-27 08:00:00Z'), "hello2");
    Map<String, int> res_after = makeVisitsHist(all_files);
    expect(res_prev["שלישי"], res_after["שלישי"] - 1);
    expect(res_prev["שני"], res_after["שני"] - 1);
    expect(res_prev["ראשון"], res_after["ראשון"]);
    expect(res_prev["רביעי"], res_after["רביעי"]);
    expect(res_prev["חמישי"], res_after["חמישי"]);
    expect(res_prev["שישי"], res_after["שישי"]);
    expect(res_prev["שבת"], res_after["שבת"]);
  });
  test("test statistics attendance multiple insertions single client",
      () async {
    Map<String, int> res_prev = makeVisitsHist(all_files);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    mockatt.postAttendance(DateTime.parse('2022-07-02 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-07-01 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-30 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-29 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-28 20:18:04Z'), "hello");
    mockatt.postAttendance(DateTime.parse('2022-06-27 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-26 08:00:00Z'), "hello2");
    Map<String, int> res_after = makeVisitsHist(all_files);
    expect(res_prev["שלישי"], res_after["שלישי"] - 1);
    expect(res_prev["שני"], res_after["שני"] - 1);
    expect(res_prev["ראשון"], res_after["ראשון"] - 1);
    expect(res_prev["רביעי"], res_after["רביעי"] - 1);
    expect(res_prev["חמישי"], res_after["חמישי"] - 1);
    expect(res_prev["שישי"], res_after["שישי"] - 1);
    expect(res_prev["שבת"], res_after["שבת"] - 1);
  });
  test("test statistics attendance multiple insertions multiple clients",
      () async {
    Map<String, int> res_prev = makeVisitsHist(all_files);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    mockatt.postAttendance(DateTime.parse('2022-07-02 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-07-01 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-30 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-29 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-28 20:18:04Z'), "hello");
    mockatt.postAttendance(DateTime.parse('2022-06-27 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-26 08:00:00Z'), "hello2");
    mockatt.desClientkeySetup("client2", "אוכלוסיה ערבית");
    mockatt.postAttendance(DateTime.parse('2022-07-02 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-07-01 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-30 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-29 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-28 20:18:04Z'), "hello");
    mockatt.postAttendance(DateTime.parse('2022-06-27 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-26 08:00:00Z'), "hello2");
    mockatt.desClientkeySetup("client3", "אוכלוסיה ערבית");
    mockatt.postAttendance(DateTime.parse('2022-06-25 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-24 08:00:00Z'), "hello2");
    mockatt.postAttendance(DateTime.parse('2022-06-23 08:00:00Z'), "hello2");

    Map<String, int> res_after = makeVisitsHist(all_files);
    expect(res_prev["שלישי"], res_after["שלישי"] - 2);
    expect(res_prev["שני"], res_after["שני"] - 2);
    expect(res_prev["ראשון"], res_after["ראשון"] - 2);
    expect(res_prev["רביעי"], res_after["רביעי"] - 2);
    expect(res_prev["חמישי"], res_after["חמישי"] - 3);
    expect(res_prev["שישי"], res_after["שישי"] - 3);
    expect(res_prev["שבת"], res_after["שבת"] - 3);
  });
  test("test statistics distribution initial", () async {
    Map<String, int> res = makeNationalitiesHist(all_files);
    expect(res.isEmpty, true);
  });
  test("test statistics distribution single client single insertion", () async {
    Map<String, int> res = makeNationalitiesHist(all_files);
    expect(res.isEmpty, true);
    mockatt.desClientkeySetup("client1", "אוכלוסיה יהודית");
    res = makeNationalitiesHist(all_files);
    expect(res["אוכלוסיה יהודית"], 1);
  });
  test("test statistics distribution empty nationality", () async {
    Map<String, int> res = makeNationalitiesHist(all_files);
    expect(res.isEmpty, true);
    mockatt.desClientkeySetup("client1", "");
    res = makeNationalitiesHist(all_files);
    expect(res["לא ידוע"], 1);
  });
  test("test statistics distribution initial", () async {
    Map<String, int> res = makeNationalitiesHist(all_files);
    expect(res.isEmpty, true);
  });
  test("test statistics distribution initial", () async {
    Map<String, int> res = makeNationalitiesHist(all_files);
    expect(res.isEmpty, true);
  });
}
