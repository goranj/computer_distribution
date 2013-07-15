part of computer_distribution;

class Student {
  final String personId;
  final String studentName;
  final String distEvent;
  final String computerId;
  final String distTime;
  var dbKey;

  Student(this.personId, this.studentName, this.distEvent,this.computerId, this.distTime);

  String toString() => '$personId - $studentName, $distEvent, $computerId, $distTime';

  // Constructor which creates a milestone
  // from the value (a Map) stored in the database.
  Student.fromRaw(key, Map value):
    dbKey = key,
    personId = value['personId'],
    studentName = value['studentName'],
    distEvent = value['distEvent'],
    computerId = value['computerId'],
    distTime = value['distTime'] {
  }

  // Serialize this to an object (a Map) to insert into the database.
  Map toRaw() {
    return {
      'personId': personId,
      'studentName': studentName,
      'distEvent': distEvent,
      'computerId': computerId,
      'distTime': distTime
    };
  }
}
