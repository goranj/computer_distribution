import 'package:web_ui/web_ui.dart';
import 'computer_distribution.dart';

class CompDistComponent extends WebComponent {

  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

//  void loadData() {
//    print('load clicked');
//
//    var pId = '5507172939';
//    var sName = 'Göran Johansson';
//    appObject.addStudent(pId, sName);
//
//    pId = '8503263033';
//    sName = 'Carl-Johan Wardman';
//    appObject.addStudent(pId, sName);
//  }

  void createDb() {
    appObject.start()
    .catchError((e) {
  //    (query('#addbutton') as ButtonElement).disabled = true;
  //    (query('#clearbutton') as ButtonElement).disabled = true;
      errorMsg = e.toString();
    });
  }

  void deleteDb() {
    appObject.deleteDb()
    .catchError((e) {
  //    (query('#addbutton') as ButtonElement).disabled = true;
  //    (query('#clearbutton') as ButtonElement).disabled = true;
      errorMsg = e.toString();
    });
  }

/*
 * Life-cycle bizness
 */
//void created() {
//  appObject.start()
//  .catchError((e) {
//    (query('#addbutton') as ButtonElement).disabled = true;
//    (query('#clearbutton') as ButtonElement).disabled = true;
//    errorMsg = e.toString();
//  });
//}
}

