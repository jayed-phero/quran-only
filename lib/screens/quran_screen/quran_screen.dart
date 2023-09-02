import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quran_only/globals.dart';
import 'package:quran_only/models/surah.dart';
import 'package:quran_only/screens/quran_screen/detail_sura_screen.dart';

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  late Future<List<Surah>> _surahListFuture;
  late AsyncSnapshot<List<Surah>> _snapshot;

  @override
  void initState() {
    super.initState();
    _surahListFuture = _getSurahList();
  }

  Future<List<Surah>> _getSurahList() async {
    String data = await rootBundle.loadString('assets/datas/sura_list.json');
    print(data);
    return surahFromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _surahListFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        _snapshot = snapshot;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: _appBar(),
            body: Container(
              color: bgGray,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: tabbar,
                      ),
                      // Example background color
                      child: TabBar(
                        tabs: const [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Surah',
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Juz',
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                        labelColor: Colors.black54,
                        unselectedLabelColor: Colors.black38,
                        indicator: BoxDecoration(
                          color: bgGray,
                          // Customize the indicator color here
                          borderRadius: BorderRadius.circular(11),
                        ),
                        indicatorPadding: EdgeInsets.zero,
                        // label: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTab1Content(),
                        _buildTab2Content(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab1Content() {
    return ListView.builder(
      itemBuilder: (context, index) =>
          _surahItem(context: context, surah: _snapshot.data!.elementAt(index)),
      // separatorBuilder: (context, index) => Divider(
      //   color: Color.fromARGB(255, 197, 82, 16).withOpacity(.35),
      // ),
      itemCount: _snapshot.data!.length,
    );
  }

  Widget _buildTab2Content() {
    // Replace this with your content for Tab 2
    return const Center(
      child: Text('Tab 2 Content'),
    );
  }

  Widget _surahItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) =>
          //       DetailScreen(noSurat: surah.nomor, suraName: surah.namaLatin),
          // ));

          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft, // Right-to-Left Transition
              child: DetailScreen(
                  noSurat: surah.nomor,
                  suraName: surah.namaLatin,
                  surahInfo: surah), // Navigate to ScreenB
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          // color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // Add the box shadow here
              BoxShadow(
                color: gray.withOpacity(0.1),
                spreadRadius: 0.3,
                blurRadius: 0.1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/nomor-surah.svg',
                    color: grColor,
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Text(
                        '${surah.nomor}',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.namaLatin,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        surah.tempatTurun.name,
                        style: GoogleFonts.poppins(
                            color: text,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: text),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${surah.jumlahAyat} Ayah",
                        style: GoogleFonts.poppins(
                            color: text,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      )
                    ],
                  )
                ],
              )),
              Row(
                children: [
                  Text(
                    surah.nama,
                    style: GoogleFonts.amiri(
                        color: grColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle onPressed action here
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black38,
                      size: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  AppBar _appBar() {
    return AppBar(
      backgroundColor: background,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/menu-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            'Holy Quran',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search-icon.svg'))
        ],
      ),
    );
  }
}
