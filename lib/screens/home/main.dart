/*
 * COPYRIGHT (c) 2022 Lavenes.
 * COPYRIGHT (c) 2022 Nhats Devil.
 *
 * This document is the property of Lavenes.
 * It is considered confidential and proprietary.
 *
 * This document may not be reproduced or transmitted in any form,
 * in whole or in part, without the express written permission of
 * Lavenes.
 */

import "package:flutter/material.dart";
import "package:quizz/lavenes.dart";
import "../../global/global.dart";
//import "../../global/qrScan.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/cupertino.dart";
import "../../api/main.dart";
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email'
  ],
);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _quizList = [];
  Map<dynamic, dynamic>? userData;
  String userRanking = "";
  int userRankNum = 0;
  int rankTotal = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  void _fetchData() async{
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString("email") == null || prefs.getString("name") == null || prefs.getString("userId") == null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
    }else {
      QuizAPI.getAll().then((value) {
        var filteredData = value["data"];
        filteredData.removeWhere((item) => item["status"] == "hidden");

        setState(() {
          _quizList = filteredData;
        });
      });
      
      UserAPI.getUserData().then((value) {
        if(value["moreData"]?["gems"] == null) {
          value["moreData"] = {
            "gems": 3000
          };
        }

        prefs.setInt("gems", value["moreData"]["gems"]);
        
        setState(() {
          userData = value;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    void _handleLogout() async {
      final prefs = await SharedPreferences.getInstance();

      prefs.remove("avatar");
      prefs.remove("name");
      prefs.remove("email");
      prefs.remove("gems");
      prefs.remove("userId");
      prefs.remove("companyId");

      await _googleSignIn.disconnect();

      Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Container(
              padding: EdgeInsets.only(top: isMobile(context) ? 64 : 24, bottom: 24),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: !isLoading ? [
                  //*HEADER BAR
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Row(
                      children: [
                        //*QR SCAN BUTTON
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/qr_scan");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 24),
                            padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                            decoration: const BoxDecoration(
                              //borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2),
                              //     blurRadius: 4,
                              //     offset: Offset(0, 2)
                              //   )
                              // ]
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                            ),
                          )
                        ),

                        Expanded(child: Container()),
                        //*AVATAR
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 24),
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24)
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 24,
                                  child: ClipRRect(
                                    child: userData?["avatar"] != null ?
                                      Image.network(userData?["avatar"]) :
                                      Image.asset("assets/avatars/a1.png"),
                                    borderRadius: BorderRadius.circular(24.0),
                                  )
                                ),
                              ),
                              Positioned(
                                child: PopupMenuButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                         Radius.circular(12.0),
                                    ),
                                  ),
                                  icon: const Icon(Icons.safety_divider, color: Colors.transparent),
                                  itemBuilder: (context) {
                                     List<PopupMenuEntry<Object>> list =[];

                                    list.add(
                                      PopupMenuItem(
                                        onTap: () async{
                                          const url = 'https://privacy.lavenes.com/beehero.html';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: const Text(
                                          "Chính sách dữ liệu",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                          ),
                                        )
                                      )
                                    );

                                    list.add(
                                      PopupMenuItem(
                                        onTap: () {
                                          _handleLogout();
                                        },
                                        child: const Text(
                                          "Đăng xuất",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                          ),
                                        )
                                      )
                                    );

                                    return list;
                                  }
                                )
                              )
                            ]
                          ),
                        )
                      ],
                    ),
                  ),

                  //*SECTION TITLE
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Xin chào ${userData?["name"]} 👋",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          "Quiz Nổi Bật",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //*FEATURE QUIZ CONTAINER
                  Container(
                    height: 468,
                    child: _quizList.length > 0 ? ListView.separated(
                      padding: const EdgeInsets.only(left: 48, right: 48),
                      scrollDirection: Axis.horizontal,
                      itemCount: _quizList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 24),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> item = _quizList[index];

                        return FeatureQuizCard(
                          title: item["title"]!, 
                          subtitle: item["description"]!, 
                          image: item["banner"]!, 
                          purple: item["moreData"]?["color"] == "purple",
                          orange: item["moreData"]?["color"] == "orange",
                          onTap: () {
                            Navigator.pushNamed(context, "/quiz", arguments: item["_id"]);
                          }
                        );
                      },
                    ) : Center(
                      child: Text(
                        "Hiện tại app không có quiz",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.32)
                        ),
                      )
                    ),
                  ),

                  //*DESKTOP & TABLET
                  Flex(
                    verticalDirection: isMobile(context) ? VerticalDirection.up : VerticalDirection.down,
                    direction: isMobile(context) ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isMobile(context) ? 0 : 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //*SECTION HEADER
                            Container(
                              margin: const EdgeInsets.only(left: 24),
                              child: const Text(
                                "💡 Quiz trong ngày",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            //* DETAIL QUIZ CONTAINER
                            const SizedBox(height: 24),
                            _quizList.length > 0 ? ListView.separated(
                              padding: const EdgeInsets.only(left: 48, right: 48),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => const SizedBox(height: 24),
                              itemCount: _quizList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> item = _quizList[index];

                                return DetailQuizCard(
                                  title: item["title"]!, 
                                  subtitle: item["description"]!, 
                                  image: item["banner"]!, 
                                  purple: item["moreData"]?["color"] == "purple",
                                  orange: item["moreData"]?["color"] == "orange",
                                  onTap: () {
                                    Navigator.pushNamed(context, "/quiz", arguments: item["_id"]);
                                  }
                                );
                              },
                            )  : Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 48, bottom: 48),
                                child: Text(
                                "Hiện tại app không có quiz",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(.32)
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24, height: 48,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //*SECTION HEADER
                          Container(
                            margin: const EdgeInsets.only(left: 24),
                            child: const Text(
                              "🏆 Thông tin thêm",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          //*RANKING GROUP
                          const SizedBox(height: 24),
                          RankingGroup()
                        ],
                      )
                    ],
                  ),
                  Footer()
                ] : [
                  Container(
                    height: MediaQuery.of(context).size.height - 96,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //*LOADING
                        CupertinoActivityIndicator(
                          animating: true,
                          color: Colors.black,
                          radius: 14,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Bạn đợi một chút xíu nhé 😘",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  //* RANKING GROUP
  Widget RankingGroup() {
    return Container(
      margin: const EdgeInsets.only(left: 48, right: 48),
      width: isMobile(context) ? null : 350,
      padding: const EdgeInsets.only(left: 32, top: 20, bottom: 20, right: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          )
        ]
      ),
      child: Row(
        children: [
          //*RANK
          // Expanded(
          //   child: Row(
          //     children: [
          //       Image.asset("assets/icons/${Global.getUserRankBadge(
          //         userRankNum,
          //         rankTotal
          //       )}", height: 40), //*ICON
          //       const SizedBox(width: 16),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text( //*TITLE
          //             "Xếp Hạng",
          //             style: TextStyle(
          //               fontSize: 12,
          //               fontWeight: FontWeight.w600,
          //               color: Color(0xFFabafb2)
          //             ),
          //           ),
          //           const SizedBox(height: 5),
          //           Text( //*VALUE
          //             userRanking,
          //             style: const TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.w700,
          //               color: Color(0xFF444444)
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(width: 24),

          //*GEMS
          Expanded(
            child: Row(
              children: [
                Image.asset("assets/icons/gems.png", height: 40), //*ICON
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text( //*TITLE
                      "Gems",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFabafb2)
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text( //*VALUE
                      userData?["moreData"]["gems"].toString() ?? "0",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF444444)
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}