import 'imports.dart';

class LifeCycleManager extends StatefulWidget {
  LifeCycleManager({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  var ID;


  doThis() async {
    ID = await FirebaseUtilities.getUserId();
  }


  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    doThis();
    setStatus("online");



  }



  void setStatus(String status) async {
    if(ID != null){
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(ID).update({
        "status" : status
      });
    }else{
      print("UID is null");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState: $state');
    print(ID);

    if (state == AppLifecycleState.resumed) {
      setStatus("online");
    } else{
      setStatus("offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}