import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const TennisRacketApp());

class TennisRacketApp extends StatelessWidget {
  const TennisRacketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const RacketSensorScreen(),
    );
  }
}

class RacketSensorScreen extends StatefulWidget {
  const RacketSensorScreen({super.key});

  @override
  State<RacketSensorScreen> createState() => _RacketSensorScreenState();
}

class _RacketSensorScreenState extends State<RacketSensorScreen> {
  // الثوابت
  double phoneMass = 0.5;

  // القيم اللحظية
  double _force = 0.0;
  double _lastForce = 0.0;
  double _maxForce = 0.0;
  double _rotationAngle = 0.0;

  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    _accelSub = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        double acceleration = math.sqrt(
            math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2)
        );
        _force = phoneMass * acceleration;
        if (_force > _maxForce) _maxForce = _force;
      });
    });

    _gyroSub = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        double rotationData = (event.z.abs() > 0.1) ? event.z : 0;
        _rotationAngle += rotationData * (180 / math.pi) * 0.05;
      });
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tennis Racket"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      // استخدام SingleChildScrollView هو الحل الأساسي للـ Overflow
      body: SingleChildScrollView(
        child: Padding(
          // تصحيح: استخدام EdgeInsets.all بدلاً من Geometry
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              _buildStatCard("Current Force", "${_force.toStringAsFixed(2)} N", Colors.blue),
              const SizedBox(height: 12),
              _buildStatCard("Max Swing Power", "${_maxForce.toStringAsFixed(2)} N", Colors.red),
              const SizedBox(height: 12),
              _buildStatCard("Rotation Angle", "${(_rotationAngle % 360).toStringAsFixed(0)}°", Colors.green),
              const SizedBox(height: 12),
              _buildStatCard("Last Swing Power", "${_lastForce.toStringAsFixed(2)} N", Colors.orange),

              const SizedBox(height: 20),
              const Text("Adjust Phone Mass (kg)", style: TextStyle(fontSize: 16)),
              Slider(
                value: phoneMass,
                min: 0.1,
                max: 1.0,
                divisions: 9, // لجعل الاختيار أسهل
                label: "${phoneMass.toStringAsFixed(1)} kg",
                activeColor: Colors.deepPurpleAccent,
                onChanged: (val) => setState(() => phoneMass = val),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // جعل الزر بعرض الشاشة
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _lastForce = _maxForce;
                    _maxForce = 0;
                    _rotationAngle = 0;
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(" RESET ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20), // مسافة في الأسفل لراحة العين عند التمرير
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: color.withOpacity(0.8))),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}