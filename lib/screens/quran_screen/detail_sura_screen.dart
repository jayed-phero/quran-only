import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_only/globals.dart';
import 'package:quran_only/models/surah.dart';
import 'package:quran_only/models/verse.dart';
import 'dart:convert';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final int noSurat;
  final String suraName;
  final Surah surahInfo;

  const DetailScreen(
      {super.key,
      required this.noSurat,
      required this.suraName,
      required this.surahInfo});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isBanglaOnubadSelected = true;
  bool _isArabicSelected = true;
  bool _isFabMenuOpen = false;

  // Initialize SharedPreferences
  late SharedPreferences _prefs;

  // Initialize a list to store bookmarked Ayat
  List<Verse> _bookmarkedAyat = [];

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load bookmarked Ayat from SharedPreferences
    String? bookmarkedAyatJson = _prefs.getString('bookmarked_ayat');
    print(bookmarkedAyatJson);
    if (bookmarkedAyatJson != null) {
      List<dynamic> bookmarkedAyatList = jsonDecode(bookmarkedAyatJson);
      print(bookmarkedAyatList);
      _bookmarkedAyat =
          bookmarkedAyatList.map((item) => Verse.fromJson(item)).toList();
      print(_bookmarkedAyat);
    }
  }

  Future<SuraAyays> _getDetailSurah() async {
    String data =
        await rootBundle.loadString('assets/bn/${widget.noSurat}.json');
    return suraAyaysFromJson(data);
  }

  // Function to check if the Ayat is bookmarked
  bool _isAyatBookmarked(Verse ayat) {
    return _bookmarkedAyat.any((bookmark) => bookmark.id == ayat.id);
  }

  // Function to toggle bookmark for an Ayat
  void _toggleBookmark(Verse ayat) {
    setState(() {
      if (_isAyatBookmarked(ayat)) {
        _bookmarkedAyat.removeWhere((bookmark) => bookmark.id == ayat.id);
        _showBookmarkSnackbar('Ayat unbookmarked.');
      } else {
        _bookmarkedAyat.add(ayat);
        _showBookmarkSnackbar('Ayat bookmarked.');
      }

      // Save the updated bookmarked Ayat list to SharedPreferences
      _prefs.setString('bookmarked_ayat', jsonEncode(_bookmarkedAyat));
    });
  }

  // Function to show a Snackbar indicating bookmark status
  void _showBookmarkSnackbar(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  void _copyToClipboard(BuildContext context, Verse ayat) {
    String clipboardText =
        'Ayat : ${ayat.text}\nTranslation : ${ayat.translation}\nSura Number : ${widget.noSurat}\nAyat Number : ${ayat.id}';

    Clipboard.setData(ClipboardData(text: clipboardText));

    // Show a tooltip for successful copy
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        const SnackBar(content: Text('Ayat copied successfully!')));
  }

  // Function to share the Ayat's content
  void _shareAyat(BuildContext context, Verse ayat) {
    String shareText =
        'Ayat : ${ayat.text}\nTranslation : ${ayat.translation}\nSura Number : ${widget.noSurat}\nAyat Number : ${ayat.id}';

    Share.share(shareText);
  }

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SuraAyays>(
      future: _getDetailSurah(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: background,
          );
        }
        SuraAyays suraAyays = snapshot.data!;
        print(suraAyays);
        //  AyatDetail firstAyatDetail = suraAyays.verses[0];
        return Scaffold(
          body: Container(
            color: bgGray,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, suraAyays),
                SliverPersistentHeader(
                  delegate: _SliverHeaderDelegate(
                    minHeight: 50,
                    maxHeight: 50,
                    child: _buildHeaderContent(),
                  ),
                  pinned: false,
                ),
                SliverToBoxAdapter(
                  child: _details(
                      surah: widget.surahInfo // Display the first AyatDetail
                      ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ayatItem(
                      context: context,
                      ayat: suraAyays.verses[index],
                      isBanglaOnubadSelected: _isBanglaOnubadSelected,
                      isArabicSelected: _isArabicSelected,
                    ),
                    childCount: suraAyays.totalVerses,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Draggable(
            feedback: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.menu),
            ),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isFabMenuOpen = !_isFabMenuOpen; // Toggle the menu
                });
              },
              child: _isFabMenuOpen
                  ? const Icon(Icons.close)
                  : const Icon(Icons.menu),
            ),
            onDragStarted: () {
              setState(() {
                _isFabMenuOpen = false; // Close the menu when dragging starts
              });
            },
            onDraggableCanceled: (_, __) {
              setState(() {
                _isFabMenuOpen =
                    false; // Close the menu when dragging is canceled
              });
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _details({required Surah surah}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Stack(children: [
          Container(
            height: 257,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      .6,
                      1
                    ],
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ])),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                  opacity: .2,
                  child: SvgPicture.asset(
                    'assets/svgs/quran.svg',
                    width: 324 - 55,
                  ))),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  surah.namaLatin,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 26),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  surah.arti,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Divider(
                  color: Colors.white.withOpacity(.35),
                  thickness: 2,
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah.tempatTurun.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${surah.jumlahAyat} Ayat",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SvgPicture.asset('assets/svgs/bismillah.svg')
              ],
            ),
          )
        ]),
      );

  Widget _ayatItem({
    required BuildContext context,
    required Verse ayat,
    required bool isBanglaOnubadSelected,
    required bool isArabicSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
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
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              // margin: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: _isAyatBookmarked(ayat) ? Colors.green : primary,
                      borderRadius: BorderRadius.circular(27 / 2),
                    ),
                    child: Center(
                      child: Text(
                        '${ayat.id}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _copyToClipboard(context, ayat); // Pass context here
                    },
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.grey,
                    ),
                    tooltip: 'Copy Ayat',
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      _toggleBookmark(ayat); // Toggle bookmark for this Ayat
                    },
                    icon: Icon(
                      _isAyatBookmarked(ayat)
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: Colors.grey,
                    ),
                    tooltip: _isAyatBookmarked(ayat)
                        ? 'Unbookmark Ayat'
                        : 'Bookmark Ayat',
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      _shareAyat(context, ayat); // Share the Ayat
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.grey,
                    ),
                    tooltip: 'Share Ayat',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            if (isArabicSelected)
              Text(
                ayat.text,
                style: const TextStyle(
                  fontFamily: 'AlQalamQuranMajeedWeb',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 37,
                ),
                textAlign: TextAlign.right,
              ),
            const SizedBox(
              height: 25,
            ),
            if (isBanglaOnubadSelected)
              Text(
                ayat.translation,
                style: const TextStyle(
                  fontFamily: 'Kalpurush',
                  color: Colors.black87,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, SuraAyays surah) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
          ),
          const SizedBox(width: 24),
          Text(
            surah.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
          ),
        ],
      ),
      pinned: true,
      floating: true,
      snap: true,
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCheckbox('Bangla Onubad', _isBanglaOnubadSelected, (value) {
              setState(() {
                if (_isArabicSelected || value!) {
                  _isBanglaOnubadSelected = value!;
                } else {
                  _showSnackBarMessage();
                }
              });
            }),
            _buildCheckbox('Arabic', _isArabicSelected, (value) {
              setState(() {
                if (_isBanglaOnubadSelected || value!) {
                  _isArabicSelected = value!;
                } else {
                  _showSnackBarMessage();
                }
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title),
      ],
    );
  }

  void _showSnackBarMessage() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('At least one language must be selected.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
