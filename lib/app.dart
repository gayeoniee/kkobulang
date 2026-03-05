import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
import 'pages/products_page.dart';
import 'pages/diary_page.dart';
import 'pages/community_page.dart';
import 'pages/profile_page.dart';

class KkobulangApp extends StatelessWidget {
  const KkobulangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '꼬불랑',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      // 데스크탑 브라우저에서 폰 크기(390px)로 제한
      builder: (context, child) {
        final width = MediaQuery.of(context).size.width;
        if (width <= 768) return child!;
        return Container(
          color: const Color(0xFFE8DDD4),
          child: Center(
            child: SizedBox(
              width: 390,
              child: ClipRect(child: child!),
            ),
          ),
        );
      },
      home: const _Root(),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  String? _curlType;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    if (_curlType == null) {
      return OnboardingPage(
        onComplete: (type) => setState(() { _curlType = type; _tab = 0; }),
      );
    }

    final pages = [
      HomePage(curlType: _curlType!, onNavigate: (i) => setState(() => _tab = i)),
      ProductsPage(curlType: _curlType!),
      const DiaryPage(),
      CommunityPage(curlType: _curlType!),
      ProfilePage(
        curlType: _curlType!,
        onChangeCurlType: (t) => setState(() => _curlType = t),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_tab == 0 ? Icons.home_rounded : Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(_tab == 1 ? Icons.grid_view_rounded : Icons.grid_view_outlined),
            label: '제품',
          ),
          BottomNavigationBarItem(
            icon: Icon(_tab == 2 ? Icons.book_rounded : Icons.book_outlined),
            label: '다이어리',
          ),
          BottomNavigationBarItem(
            icon: Icon(_tab == 3 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline_rounded),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(_tab == 4 ? Icons.person_rounded : Icons.person_outline_rounded),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
