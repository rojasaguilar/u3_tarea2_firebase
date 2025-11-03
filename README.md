# u3_tarea2_firebase

A new Flutter project.

## Getting Started

1. Generar app en firebase
2. Configurar archivos base de firebase en Proyecto android
3. Descargar core .pub de firebase y depues las demas apps que queramos utilizar https://firebase.flutter.dev/
4. Agregar estas lineas a main
   WidgetsFlutterBinding.ensureInitialized();
5. En el state, agregar:
```dart
class _MyHomePageState extends State<MyHomePage> {
   final Future<FirebaseApp> _fApp = Firebase.initializeApp();
   String realTimeValue = "0";
   String getOnceValue = "0";
   @override
   Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar(
                 backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                 title: Text(widget.title),
              ),
              body: FutureBuilder(future: _fApp, builder: (context, snapshot){
                 if(snapshot.hasError){
                    return Text("Somethings bad with firebase");
                 }else if(snapshot.hasData){
                    return content();
                 }else{
                    return CircularProgressIndicator();
                 }
              })
      );
   }}
```