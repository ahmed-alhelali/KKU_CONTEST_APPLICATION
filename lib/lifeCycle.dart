import 'imports.dart';

class LifeCycleManager extends StatefulWidget {
  LifeCycleManager({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {

  @override
  void initState() {
    setStatus("online");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void setStatus(String status) async {
    if (FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
      final snapShot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid).get();

      if(snapShot.exists){
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({"status": status, "last_seen": DateTime.now()});
      }else{
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({"uid":FirebaseAuth.instance.currentUser.uid,"status": status, "last_seen": DateTime.now()});
      }

    } else {
      print("just ignore the action because we don't have user");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState: $state');

    if (state == AppLifecycleState.resumed) {
      setStatus("online");
    } else {
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
