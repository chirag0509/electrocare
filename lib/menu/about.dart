import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  Future<void> _launchurlWasp() async {
    Uri _url = Uri.parse('https://whatsapp.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlInsta() async {
    Uri _url = Uri.parse('https://instagram.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlFacebook() async {
    Uri _url = Uri.parse('https://www.facebook.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlTwitter() async {
    Uri _url = Uri.parse('https://twitter.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final color = ColorController.instance;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
      ),
      drawer: DrawerCom.instance.drawer,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "About Us",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: w * 0.35,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Our Story',
                            style: TextStyle(
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "At ElectroCare, we understand the importance of your valuable electronic appliances and the inconvenience caused by their malfunctioning. That's why we've designed our app to provide a seamless and efficient repair process, making your life easier.",
                            style: TextStyle(fontSize: w * 0.035),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Meet the Team',
                style:
                    TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10),
                child: Text(
                  '- Pankaj Rawat',
                  style: TextStyle(
                      fontSize: w * 0.035, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10),
                child: Text(
                  '- Chirag Jathan',
                  style: TextStyle(
                      fontSize: w * 0.035, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10),
                child: Text(
                  '- Swastik Sahu',
                  style: TextStyle(
                      fontSize: w * 0.035, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Here's what sets us apart:",
                style:
                    TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Expert Technicians: Our team of highly skilled and certified technicians are equipped with extensive knowledge and experience in repairing a wide range of electronic appliances. They undergo rigorous training to stay up-to-date with the latest industry advancements, ensuring that they can handle any repair job with precision and expertise.'
                  '\n\nDoor-to-Door Convenience: Say goodbye to the hassle of transporting your damaged appliance to a repair shop. With our door-to-door service, all you need to do is schedule an appointment through the app, and our technician will arrive at your doorstep at your preferred time. We bring the repair shop to you, saving you time and effort.'
                  '\n\nQuality Repairs: We are committed to providing top-notch repairs that stand the test of time. We use only genuine parts and high-quality tools to ensure that your appliance is restored to its optimal functionality. Our technicians employ meticulous attention to detail, leaving no room for compromise when it comes to quality.'
                  '\n\nTransparent Pricing: We believe in transparency and fairness. Our app provides clear and upfront pricing, so you know exactly what to expect before scheduling a repair. There are no hidden costs or surprises along the way. Rest assured, you will receive exceptional service at a competitive price.'
                  '\n\nExcellent Customer Support: Your satisfaction is our priority. Our dedicated customer support team is available to address any queries or concerns you may have throughout the repair process. We value your feedback and continuously strive to improve our services to exceed your expectations.'
                  '\n\nChoose ElectroCare for all your electronic appliance repair needs and experience the convenience and reliability of our door-to-door service. Download our app today and let us take care of your repairs, so you can get back to enjoying your fully functional appliances without any worries.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: w * 0.035,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      "Follow us on: ",
                      style: TextStyle(
                          fontSize: w * 0.045, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color.fromRGBO(37, 211, 102, 1),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlWasp();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFFF03b5998),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlFacebook();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Color.fromRGBO(255, 87, 51, 1.0),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlInsta();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Color(0xFFF00acee),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlTwitter();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontSize: w * 0.045,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '07, New Road, Mumbai',
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hours:',
                      style: TextStyle(
                        fontSize: w * 0.045,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mon-Fri: 11am - 9pm',
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
