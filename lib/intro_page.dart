import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'login_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.5),],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const FlagAnimation(),
                  const SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.lightBlueAccent,
                    period: const Duration(seconds: 2),
                    child: const Text(
                      'Civic Fix',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ),
                  const Text(
                    'Making Incredible India',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const IssuesGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlagAnimation extends StatelessWidget {
  const FlagAnimation({super.key});

  final String ashokaChakraAsset = 'assets/images/ashok_chakra.jpg';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 108.0,
          width: 200.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The flag stripes
              Column(
                children: [
                  Container(
                    height: 36.0,
                    color: const Color(0xFFFF9933),
                  ),
                  Container(
                    height: 36.0,
                    color: Colors.white,
                  ),
                  Container(
                    height: 36.0,
                    color: const Color(0xFF138808),
                  ),
                ],
              ),

              Image.asset(
                ashokaChakraAsset,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class IssuesGrid extends StatelessWidget {
  const IssuesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: const [
        IssueCard(
          icon: Icons.wc,
          label: 'Dirty Toilets',
          color: Colors.blue,
        ),
        IssueCard(
          icon: Icons.delete,
          label: 'Garbage Disposal',
          color: Colors.green,
        ),
        IssueCard(
          icon: Icons.star,
          label: 'Rating',
          color: Colors.orange,
        ),
        IssueCard(
          icon: Icons.report_problem,
          label: 'Potholes',
          color: Colors.red,
        ),
        IssueCard(
          icon: Icons.image,
          label: 'Upload image',
          color: Colors.cyan,
        ),
        IssueCard(
          icon: Icons.local_shipping,
          label: 'Waste Management',
          color: Colors.brown,
        ),
      ],
    );
  }
}

class IssueCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const IssueCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: color.withOpacity(0.9),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label clicked!'),
              backgroundColor: color,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),

      ),
    );
  }
}
