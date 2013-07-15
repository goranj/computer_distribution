library computer_distribution;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:indexed_db';
import 'dart:async';

part 'student.dart';
part 'computer.dart';
part 'comp_dist_store.dart';

/*
 * The VIEW-MODEL for the app.
 *
 * Implements the business logic
 * and manages the information exchanges
 * between the MODEL (Milestone & MilestoneStore)
 * and the VIEW (CountDownComponent & MilestoneComponent).
 *
 * Manages a Timer to update the milestones.
 */

ComputerDistributionApp appObject = new ComputerDistributionApp();


void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
}

class ComputerDistributionApp {

  // Is IndexedDB supported in this browser?
  bool idbAvailable = IdbFactory.supported;

  // A place to save the data (is the MODEL).
  ComputerDistributionStore _store = new ComputerDistributionStore();

  // The list of students in the MODEL.
  List<Student> get students => _store.students;
  List<Computer> get computers => _store.computers;

//  void addStudent(String personId, String studentName) {
//    _store.addStudent(personId, studentName).then((student) {
//      print(student);
//    },
//    onError: (e) { print('duplicate key'); });
////      _store.add(personId, personId).then((_) {
////        print('student added');
////      },
////      onError: (e) { print('duplicate key'); } );
//  }

  /****
   * Life-cycle methods...
   */
  // Called from the VIEW when the element is inserted into the DOM.
  Future start() {
    if (!idbAvailable) {
      return new Future.error('IndexedDB not supported.');
    }

    return _store.open().then((_) {
//      _startMilestoneTimer();
    });
  }

  Future deleteDb() {
    return _store.delete().then((_) {
      print('db deleted');
    });
  }

}
