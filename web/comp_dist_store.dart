part of computer_distribution;

class ComputerDistributionStore {
  static const String STUDENT_STORE = 'studentStore';
  static const String COMPUTER_STORE = 'computerStore';
  static const String PID_INDEX = 'personId_index';
  static const String ACODE_INDEX = 'antitheftCode_index';

  final List<Student> students = toObservable(new List());
  final List<Computer> computers = toObservable(new List());

  Database _db;

  Future delete() {
    _db = null;
    return window.indexedDB.deleteDatabase('compdistDB').then((_) => print('db deleted'));
  }

  Future open() {
    return window.indexedDB.open('compdistDB',
        version: 1,
        onUpgradeNeeded: _initializeDatabase)
      .then(_loadFromDB);
  }

  // Initializes the object store if it is brand new,
  // or upgrades it if the version is older.
  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;

    var studentStore = db.createObjectStore(STUDENT_STORE,
        autoIncrement: true);

    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate milestone names.
    studentStore.createIndex(PID_INDEX, 'personId', unique: true);

    var computerStore = db.createObjectStore(COMPUTER_STORE,
        autoIncrement: true);

    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate milestone names.
    computerStore.createIndex(ACODE_INDEX, 'antitheftCode', unique: true);

    print('db created');
  }

  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  Future _loadFromDB(Database db) {
    _db = db;
    var trans = db.transaction(STUDENT_STORE, 'readonly');
    var store = trans.objectStore(STUDENT_STORE);
    store.count().then(loadStudents)
    .then((_) {
      print('students loaded to db');
      var trans = db.transaction(STUDENT_STORE, 'readonly');
      var store = trans.objectStore(STUDENT_STORE);

      // Get everything in the store.
      var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
      cursors.listen((cursor) {
        // Add milestone to the internal list.
        var student = new Student.fromRaw(cursor.key, cursor.value);
        students.add(student);
      });
      return cursors.length.then((_) {
        return students.length;
      });
    });

    trans = db.transaction(COMPUTER_STORE, 'readonly');
    store = trans.objectStore(COMPUTER_STORE);
    store.count().then(loadComputers)
    .then((_) {
      print('computers loaded to db');
      var trans = db.transaction(COMPUTER_STORE, 'readonly');
      var store = trans.objectStore(COMPUTER_STORE);

      // Get everything in the store.
      var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
      cursors.listen((cursor) {
        // Add milestone to the internal list.
        var computer = new Computer.fromRaw(cursor.key, cursor.value);
        computers.add(computer);
      });
      return cursors.length.then((_) {
        return computers.length;
      });
    });
  }

  // Add a new student to the students in the Database.
  //
  // This returns a Future with the new student when the student
  // has been added.
  Future<Student> addStudent(String personId, String studentName, String distEvent, String computerId, String distTime) {
    var student = new Student(personId, studentName, distEvent, computerId, distTime);
    var studentAsMap = student.toRaw();

    var transaction = _db.transaction(STUDENT_STORE, 'readwrite');
    var objectStore = transaction.objectStore(STUDENT_STORE);


    objectStore.add(studentAsMap).then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.
      student.dbKey = addedKey;
    });

    // Note that the student cannot be queried until the transaction
    // has completed!
    return transaction.completed.then((_) {
      // Once the transaction completes, add it to our list of available items.
      //students.add(student);

      // Return the student so this becomes the result of the future.
      return student;
    });
  }

  Future<Student> addComputer(String antitheftCode, String serialNo, String studentId) {
    var computer = new Computer(antitheftCode, serialNo, studentId);
    var computerAsMap = computer.toRaw();

    var transaction = _db.transaction(COMPUTER_STORE, 'readwrite');
    var objectStore = transaction.objectStore(COMPUTER_STORE);


    objectStore.add(computerAsMap).then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.
      computer.dbKey = addedKey;
    });

    // Note that the student cannot be queried until the transaction
    // has completed!
    return transaction.completed.then((_) {
      // Once the transaction completes, add it to our list of available items.
      //computers.add(computer);

      // Return the student so this becomes the result of the future.
      return computer;
    });
  }

  // **********************
  Future loadStudents(int count) {
    if (count == 0) {
      List<Student> studentList = new List();
      studentList.add(new Student('5507172939', 'Göran Johansson', 'Lars Kagg - 2013-08-17 09:00', '', ''));
      studentList.add(new Student('8503263033', 'Carl-Johan Wardman', 'Jenny Nyström - 2013.08-17 11:00', '', ''));
      studentList.add(new Student('8702112965', 'Linn Wardman', 'Jenny Nyström - 2013.08-17 11:00', '', ''));

      List futureList = new List();
      for (Student loadStudent in studentList){
        futureList.add(addStudent(loadStudent.personId, loadStudent.studentName, loadStudent.distEvent, loadStudent.computerId, loadStudent.distTime));
      }
      var result = Future.wait(futureList);
      return result;
   }
  }

  Future loadComputers(int count) {
    if (count == 0) {
      List<Computer> computerList = new List();
      computerList.add(new Computer('111', '222', ''));
      computerList.add(new Computer('333', '444',''));

      List futureList = new List();
      for (Computer loadComputer in computerList){
        futureList.add(addComputer(loadComputer.antitheftCode, loadComputer.serialNo, loadComputer.studentId));
      }
      var result = Future.wait(futureList);
      return result;
    }
  }
}