part of computer_distribution;

class Computer {
  final String antitheftCode;
  final String serialNo;
  final String studentId;
  var dbKey;

  Computer(this.antitheftCode, this.serialNo, this.studentId);

  String toString() => '$antitheftCode - $serialNo, $studentId';

  // Constructor which creates a milestone
  // from the value (a Map) stored in the database.
  Computer.fromRaw(key, Map value):
    dbKey = key,
    antitheftCode = value['antitheftCode'],
    serialNo = value['serialNo'],
    studentId = value['studentId'] {
  }

  // Serialize this to an object (a Map) to insert into the database.
  Map toRaw() {
    return {
      'antitheftCode': antitheftCode,
      'serialNo': serialNo,
      'studentId': studentId
    };
  }
}
