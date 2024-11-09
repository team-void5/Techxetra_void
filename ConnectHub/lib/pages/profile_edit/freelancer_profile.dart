import 'package:connecthub/pages/search_screen.dart';
import 'package:connecthub/pages/services/order_service.dart';
import 'package:connecthub/pages/services/service_tile.dart';
import 'package:connecthub/pages/services/services.dart';
import 'package:connecthub/utils/my_colors.dart';
import 'package:connecthub/widgets/Review_widget.dart';
import 'package:connecthub/widgets/categories.dart';
import 'package:connecthub/widgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'freelancer/editfreelancer_Data.dart';
import 'profiledb.dart';
class FPService {
  final String title;
  final int price;
  final String description;
  final String info1;
  final String info2;
  final String info3;

  FPService(
      {required this.title,
      required this.description,
      required this.price,
      required this.info1,
      required this.info2,
      required this.info3});
}

//todo: info1,2,3 and all attributes of a class cannot be null because of Dart's Null Safety and probably will result in error even if i remove null safety.So i'll have to dynamically add more attributes when needed so that they always contain a values and those who don't are not included in the class. So when a user wants to add more info points to their service listing they can click a button and that buttons onPressed action will add another info attribute to the individual service. But then again they will have to put that additional info on all their services or the same problem will arise.Gotta figure something out.
//?: Maybe limit the number of info points to 3? Because the pageView builder also needs a fixed height

class FreelancerProfile extends StatefulWidget {
  final String freelancerId;
  final bool account;
  FreelancerProfile({required this.freelancerId, required this.account});

  @override
  _FreelancerProfileWidgetState createState() => _FreelancerProfileWidgetState();
}
class _FreelancerProfileWidgetState extends State<FreelancerProfile> {
  final List<FPService> services = [
    FPService(
      title: "Service 1",
      description: "Description of Service 1",
      price: 100,
      info1: "Info 1 for Service 1",
      info2: "Info 2 for Service 1",
      info3: "Info 3 for Service 1",
    ),
    FPService(
      title: "Service 2",
      description: "Description of Service 2",
      price: 200,
      info1: "Info 1 for Service 2",
      info2: "Info 2 for Service 2",
      info3: "Info 3 for Service 2",
    ),
  ];
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  String? name;
  String? profession;
  String? language;
  String? about;
  String? contact;
  String? experience;
  String? projects;
  String? email;
  File? _image;
  @override
  void initState() {
    super.initState();
    _fetchFreelancerData();
  }
  Future<void> _fetchFreelancerData() async {
    final User? user = _authService.getCurrentUser();
     if (user != null) {
      final userData = await _databaseService.getUserData(user.uid);
      setState(() {
      name = userData['name'] ?? '';
      profession = userData['profession'] ?? '';
      language = userData['language'] ?? '';
      about = userData['about'] ?? '';
      contact = userData['contact'] ?? '';
      experience = userData['experience'] ?? '';
      projects = userData['projects'] ?? '';
      email = userData['email'] ?? '';
      });
    }
    
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditFreelancerData()));
      }),
      
      body: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: primary,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                      child: SafeArea(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (!widget.account)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 0, 0),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_backspace_rounded,
                                      color: white,
                                      size: 28,
                                    )),
                              ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget.account)
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const EditFreelancerData()));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: white,
                                            size: 28,
                                          )),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Search()));
                                        },
                                        icon: const Icon(
                                          Icons.search,
                                          color: white,
                                          size: 28,
                                        )),
                                    const LikeButton()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
                      child: Text(
                        profession??'',
                          textAlign: TextAlign.justify,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: white)),
                    ),
                    Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _image != null ? FileImage(_image!) : null,
                                child: _image == null? Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color: Color.fromARGB(255, 22, 23, 24),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _showImageSourceActionSheet();
                                  },
                                ),
                              ),
                            ],
                          ),

                    Text(
                    name ?? '',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: white)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: RatingBarIndicator(
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            direction: Axis.horizontal,
                            rating: 4,
                            unratedColor: Colors.grey[400],
                            itemCount: 5,
                            itemPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            itemSize: 22,
                          ),
                        ),
                        Text(
                          experience??'',
                          style: TextStyle(
                            color: Color(0xFFf1f4f8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 5),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Contact Me'),
                                content: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.13,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    email??''));
                                          },
                                          style: OutlinedButton.styleFrom(
                                              shape: LinearBorder.start(
                                                  side: const BorderSide(
                                                      width: 3)),
                                              alignment: Alignment.centerLeft,
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                          child: const Text('Email'),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(
                                                    text: 
                                                    contact??'')
                                              );
                                          },
                                          style: OutlinedButton.styleFrom(
                                              shape: LinearBorder.start(
                                                  side: const BorderSide(
                                                      width: 3)),
                                              alignment: Alignment.centerLeft,
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                          child: const Text('Phone'),
                                        )
                                      ]),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              fixedSize: const Size(150, 42),
                              foregroundColor: primary,
                              backgroundColor: sbg),
                          child: const Text(
                            'Contact Me',
                            style: TextStyle(
                              color: Color(0xFF4b39ef),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Text(
                      'About Me -',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: const BoxDecoration(),
                  child: 
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                    child: Text(
                       about ?? '',
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: secondaryText)),
                  ),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                        'Projects: $projects',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Language: $language',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 400,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final FPService service = services[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: sbg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 14, 10, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    service.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryText,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Text(
                                  "₹${service.price}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryText,
                                  ),
                                ),
                              ],
                            )),
                        const Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                          child: Text(
                            service.description,
                            style: const TextStyle(
                              fontSize: 18,
                              color: secondaryText,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Flexible(
                                        child: Text(
                                      service.info1,
                                      style: const TextStyle(fontSize: 18),
                                    ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Flexible(
                                        child: Text(
                                      service.info2,
                                      style: const TextStyle(fontSize: 18),
                                    ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Flexible(
                                        child: Text(
                                      service.info3,
                                      style: const TextStyle(fontSize: 18),
                                    ))
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (!widget.account)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 12, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ratings and Reviews',
                       // style: txt.titleDark,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10, // Replace with the number of reviews
                    itemBuilder: (context, index) {
                      return ReviewWidget(
                          commentId: '$index',
                          commenterId: '$index',
                          commenterName: 'User Name $index',
                          commentBody:
                              'Comment Review Comment Review Comment Review $index',
                          commenterImageUrl: 'assets/beard.jpg',
                          commenterRating: 4);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 10),
                  child: Text(
                    'Search from different categories',
                    style: TextStyle(
                        fontSize: 24,
                        color: secondaryText,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const Category(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Recommended for you',
                        //style: txt.titleDark,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Services(
                                        srvCategory: 'recommend')));
                          },
                          child: const Text(
                            'See More',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primary),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        10, // Replace with the number of recommended services
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: MediaQuery.sizeOf(context).width * 1,
                          child: ServiceTile(
                            serviceID: '$index',
                            serviceTitle: 'Title $index',
                            serviceDesc: 'Description $index',
                            uploadedBy: '$index',
                            serviceImage: 'assets/portrait.jpg',
                            servicePrice: index * 1000 + 1000,
                            uploaderId: '$index',
                          ));
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 10, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'People also Viewed',
                        //style: txt.titleDark,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        10, // Replace with the number of recommended services
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: MediaQuery.sizeOf(context).width * 1,
                          child: ServiceTile(
                            serviceID: '$index',
                            serviceTitle: 'Title $index',
                            serviceDesc: 'Description $index',
                            uploadedBy: '$index',
                            serviceImage: 'assets/portrait.jpg',
                            servicePrice: index * 1000 + 1000,
                            uploaderId: '$index',
                          ));
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }
}