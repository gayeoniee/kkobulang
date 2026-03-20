import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../services/analytics.dart';

String postTypeIcon(String type) {
  switch (type) {
    case 'notice': return '📢';
    case 'guide': return '📖';
    case 'salon': return '💈';
    case 'tip': return '💡';
    case 'product': return '🛍';
    case 'help': return '🙏';
    default: return '💬';
  }
}

String postTypeLabel(String type) {
  switch (type) {
    case 'notice': return '공지';
    case 'guide': return '가이드';
    case 'salon': return '미용실';
    case 'tip': return '꿀팁';
    case 'product': return '제품';
    case 'help': return '도와주세요';
    default: return '기타';
  }
}

Color postTypeColor(String type) {
  switch (type) {
    case 'notice': return const Color(0xFF9B59B6);
    case 'guide': return const Color(0xFF2980B9);
    case 'salon': return AppColors.teal;
    case 'tip': return const Color(0xFFF39C12);
    case 'product': return AppColors.peach;
    case 'help': return AppColors.type4;
    default: return AppColors.brownMid;
  }
}

// 미용실 샘플 데이터 (하남시 기준)
const _salonList = [
  (name: '꼬불랑 헤어살롱', dist: '0.2km', address: '경기 하남시 대청로', rating: 4.8, nx: 0.50, ny: 0.45),
  (name: '컬리걸 헤어스튜디오', dist: '0.7km', address: '경기 하남시 신장동', rating: 4.6, nx: 0.28, ny: 0.62),
  (name: '웨이비웨이브', dist: '1.1km', address: '경기 하남시 덕풍동', rating: 4.5, nx: 0.72, ny: 0.30),
  (name: '곱슬전문 손질소', dist: '1.4km', address: '경기 하남시 풍산동', rating: 4.3, nx: 0.20, ny: 0.35),
  (name: '케어컬 스튜디오', dist: '2.0km', address: '경기 하남시 미사강변동', rating: 4.2, nx: 0.76, ny: 0.68),
];

class CommunityPage extends StatefulWidget {
  final String curlType;
  const CommunityPage({super.key, required this.curlType});
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late List<CommunityPost> _posts;
  String _filter = '전체';
  final Set<int> _liked = {};

  final _filters = ['전체', '💈미용실', '💡꿀팁', '🛍제품', '🙏도와주세요'];
  final _filterKeys = ['전체', 'salon', 'tip', 'product', 'help'];

  @override
  void initState() {
    super.initState();
    _posts = List.from(communityPosts);
  }

  List<CommunityPost> get _filtered {
    if (_filter == '전체') return _posts;
    final filterKey = _filterKeys[_filters.indexOf(_filter)];
    return _posts.where((p) => p.postType == filterKey).toList();
  }

  void _toggleLike(int id) {
    setState(() {
      final idx = _posts.indexWhere((p) => p.id == id);
      if (idx == -1) return;
      if (_liked.contains(id)) {
        _liked.remove(id);
        _posts[idx].likes--;
      } else {
        _liked.add(id);
        _posts[idx].likes++;
      }
    });
  }

  void _togglePinnedLike(int id) {
    setState(() {
      if (_liked.contains(id)) {
        _liked.remove(id);
      } else {
        _liked.add(id);
      }
    });
  }

  void _openPostForm() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PostForm(
        curlType: widget.curlType,
        onSave: (post) {
          setState(() => _posts.insert(0, post));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final isSalonView = _filter == '💈미용실';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('커뮤니티'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _openPostForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              child: const Text('글 쓰기'),
            ),
          ),
        ],
      ),
      body: Column(children: [
        // Filter chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final f = _filters[i];
              final isActive = _filter == f;
              return GestureDetector(
                onTap: () {
                  GA.event('community_filter_changed', {'filter': f});
                  setState(() => _filter = f);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.peach : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 4, offset: Offset(0,1))],
                  ),
                  child: Text(f,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.white : AppColors.brownMid)),
                ),
              );
            },
          ),
        ),

        if (!isSalonView) ...[
          // 검색바
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextField(
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: '게시글, 태그 검색...',
                prefixIcon: Icon(Icons.search, color: AppColors.brownLight),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              itemCount: (_filter == '전체' ? pinnedPosts.length : 0) + (filtered.isEmpty ? 1 : filtered.length),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                if (_filter == '전체') {
                  if (i < pinnedPosts.length) {
                    final post = pinnedPosts[i];
                    return _PostCard(
                      post: post,
                      liked: _liked.contains(post.id),
                      onLike: () => _togglePinnedLike(post.id),
                    );
                  }
                  final fi = i - pinnedPosts.length;
                  if (filtered.isEmpty) return _emptyState();
                  return _PostCard(
                    post: filtered[fi],
                    liked: _liked.contains(filtered[fi].id),
                    onLike: () => _toggleLike(filtered[fi].id),
                  );
                } else {
                  if (filtered.isEmpty) return _emptyState();
                  return _PostCard(
                    post: filtered[i],
                    liked: _liked.contains(filtered[i].id),
                    onLike: () => _toggleLike(filtered[i].id),
                  );
                }
              },
            ),
          ),
        ] else ...[
          // 미용실 뷰: 지도 + 리스트
          Expanded(child: _SalonView()),
        ],
      ]),
    );
  }

  Widget _emptyState() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const SizedBox(height: 40),
    const Text('💬', style: TextStyle(fontSize: 48)),
    const SizedBox(height: 12),
    Text('아직 글이 없어요', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
  ]));
}

// ── 미용실 지도 뷰 ─────────────────────────────────────────────────────────
class _SalonView extends StatefulWidget {
  @override
  State<_SalonView> createState() => _SalonViewState();
}

class _SalonViewState extends State<_SalonView> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    GA.event('salon_map_viewed');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 현위치 안내
      Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Icon(Icons.location_on_rounded, size: 14, color: AppColors.teal),
          const SizedBox(width: 6),
          Text('현재 위치: 경기 하남시 하남시청역',
            style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.tealDark)),
        ]),
      ),
      const SizedBox(height: 8),

      // 가짜 지도
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: LayoutBuilder(builder: (context, constraints) {
              final w = constraints.maxWidth;
              const h = 220.0;
              return Stack(children: [
                // 지도 배경
                Container(width: w, height: h, color: const Color(0xFFE8F0E9)),
                // 가로 도로
                Positioned(top: h * 0.25 - 4, left: 0, right: 0, child: Container(height: 8, color: Colors.white)),
                Positioned(top: h * 0.50 - 4, left: 0, right: 0, child: Container(height: 10, color: Colors.white)),
                Positioned(top: h * 0.75 - 3, left: 0, right: 0, child: Container(height: 6, color: Colors.white)),
                // 세로 도로
                Positioned(left: w * 0.25 - 3, top: 0, bottom: 0, child: Container(width: 6, color: Colors.white)),
                Positioned(left: w * 0.50 - 4, top: 0, bottom: 0, child: Container(width: 8, color: Colors.white)),
                Positioned(left: w * 0.75 - 3, top: 0, bottom: 0, child: Container(width: 6, color: Colors.white)),
                // 블록들
                for (final r in [
                  Rect.fromLTWH(w*0.05, h*0.05, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.28, h*0.05, w*0.19, h*0.17),
                  Rect.fromLTWH(w*0.55, h*0.05, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.05, h*0.30, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.55, h*0.30, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.05, h*0.55, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.28, h*0.55, w*0.19, h*0.17),
                  Rect.fromLTWH(w*0.55, h*0.55, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.05, h*0.78, w*0.17, h*0.17),
                  Rect.fromLTWH(w*0.55, h*0.78, w*0.17, h*0.17),
                ])
                  Positioned(
                    left: r.left, top: r.top,
                    child: Container(
                      width: r.width, height: r.height,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4E6D5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                // 현위치 파란 점 (중앙)
                Positioned(
                  left: w * 0.5 - 10, top: h * 0.5 - 10,
                  child: Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [BoxShadow(color: const Color(0xFF4285F4).withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)],
                    ),
                  ),
                ),
                // 미용실 핀들
                for (int i = 0; i < _salonList.length; i++) ...[
                  Positioned(
                    left: w * _salonList[i].nx - 16,
                    top: h * _salonList[i].ny - 16,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: _selectedIndex == i ? 8 : 5,
                          vertical: _selectedIndex == i ? 4 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedIndex == i ? AppColors.peach : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: _selectedIndex == i ? null : Border.all(color: AppColors.peach, width: 1.5),
                          boxShadow: [BoxShadow(
                            color: (_selectedIndex == i ? AppColors.peach : Colors.black).withValues(alpha: 0.25),
                            blurRadius: _selectedIndex == i ? 8 : 4,
                            offset: const Offset(0, 2),
                          )],
                        ),
                        child: Text(
                          _selectedIndex == i ? _salonList[i].name : '💈',
                          style: GoogleFonts.notoSansKr(
                            fontSize: _selectedIndex == i ? 10 : 13,
                            fontWeight: FontWeight.w700,
                            color: _selectedIndex == i ? Colors.white : AppColors.peach,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ]);
            }),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // 리스트
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('가까운 곱슬 미용실', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(width: 8),
          Text('${_salonList.length}곳', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
        ]),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: _salonList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final salon = _salonList[i];
            final isSelected = _selectedIndex == i;
            return GestureDetector(
              onTap: () {
                GA.event('salon_card_clicked', {'salon_name': salon.name});
                setState(() => _selectedIndex = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.peachLight : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.peach : Colors.transparent, width: 1.5),
                  boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 6, offset: Offset(0,2))],
                ),
                child: Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.peach.withValues(alpha: 0.15) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('💈', style: TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(salon.name, style: GoogleFonts.notoSansKr(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.peachDark : AppColors.brown)),
                    const SizedBox(height: 2),
                    Text(salon.address, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.star_rounded, size: 13, color: AppColors.star),
                      const SizedBox(width: 2),
                      Text(salon.rating.toString(),
                        style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.brown)),
                      const SizedBox(width: 8),
                      Icon(Icons.near_me_rounded, size: 12, color: AppColors.teal),
                      const SizedBox(width: 2),
                      Text(salon.dist, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.teal)),
                    ]),
                  ])),
                  if (isSelected)
                    const Icon(Icons.location_on_rounded, color: AppColors.peach, size: 20),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }
}


// ── Post Card ──────────────────────────────────────────────────────────────
class _PostCard extends StatefulWidget {
  final CommunityPost post;
  final bool liked;
  final VoidCallback onLike;
  const _PostCard({required this.post, required this.liked, required this.onLike});
  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _showComments = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isPinned = post.isPinned;
    final typeColor = postTypeColor(post.postType);

    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: typeColor.withValues(alpha: 0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(postTypeIcon(post.postType), style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 3),
              Text(postTypeLabel(post.postType),
                style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: typeColor)),
            ]),
          ),
          if (isPinned) ...[
            const SizedBox(width: 6),
            Icon(Icons.push_pin_rounded, size: 13, color: AppColors.brownLight),
          ],
          const Spacer(),
          Text(post.time, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        ]),
        const SizedBox(height: 10),

        Row(children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
            child: Center(child: Text(post.avatar, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 8),
          Text(post.author, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
          if (post.curlType.isNotEmpty) ...[
            const SizedBox(width: 6),
            CurlTypeBadge(post.curlType),
          ],
        ]),
        const SizedBox(height: 8),

        if (post.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(post.title,
              style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
          ),

        Text(post.content, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.6)),

        if (post.hasImage) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetImg(url: post.imageUrl, fallback: '📸', width: double.infinity, height: 180),
          ),
        ],

        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6,
            children: post.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Text('#$t', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownMid)),
            )).toList()),
        ],

        const SizedBox(height: 10),
        const Divider(color: AppColors.surface, height: 1),
        const SizedBox(height: 8),

        Row(children: [
          _ActionBtn(
            icon: widget.liked ? '❤️' : '🤍',
            label: '${post.likes}',
            active: widget.liked,
            onTap: widget.onLike,
          ),
          const SizedBox(width: 16),
          _ActionBtn(
            icon: '💬', label: '${post.comments}',
            onTap: () => setState(() => _showComments = !_showComments),
          ),
        ]),

        if (_showComments) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Text('🌸', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text('꼬불랑', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brown)),
                const SizedBox(width: 6),
                Text('방금 전', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
              ]),
              const SizedBox(height: 4),
              Text('따뜻한 게시글 감사해요! 꼬불랑 커뮤니티에 오신 걸 환영해요 🌿',
                style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid)),
            ]),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(
              decoration: const InputDecoration(hintText: '댓글을 입력하세요...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              style: GoogleFonts.notoSansKr(fontSize: 13),
            )),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
              child: const Text('전송'),
            ),
          ]),
        ],
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String icon, label;
  final bool active;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.notoSansKr(
        fontSize: 13, color: active ? AppColors.type4 : AppColors.brownLight,
        fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
    ]),
  );
}

// ── Post Form ──────────────────────────────────────────────────────────────
class _PostForm extends StatefulWidget {
  final String curlType;
  final void Function(CommunityPost) onSave;
  const _PostForm({required this.curlType, required this.onSave});
  @override
  State<_PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<_PostForm> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String _postType = 'tip';
  final Set<String> _selectedTags = {};
  bool _hasPhoto = false;

  final _postTypes = [
    ('tip', '💡', '꿀팁'),
    ('salon', '💈', '미용실'),
    ('product', '🛍', '제품'),
    ('help', '🙏', '도와주세요'),
  ];

  final _curlTypeTags = ['2A','2B','2C','3A','3B','3C','4A','4B','4C'];
  final _regionTags = ['서울 강남', '서울 홍대', '서울 성수', '경기 분당', '부산', '대구', '인천'];
  final _productTags = ['샴푸', '트리트먼트', '컬크림', '세럼', '젤', '오일'];

  @override
  void dispose() { _titleCtrl.dispose(); _contentCtrl.dispose(); super.dispose(); }

  List<String> get _tagOptions {
    final options = <String>[..._curlTypeTags];
    if (_postType == 'salon') options.addAll(_regionTags);
    if (_postType == 'product') options.addAll(_productTags);
    return options;
  }

  bool get _canPost => _titleCtrl.text.trim().isNotEmpty && _contentCtrl.text.trim().isNotEmpty;

  void _submit() {
    widget.onSave(CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch,
      author: '나', avatar: '😊',
      curlType: widget.curlType, time: '방금 전',
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      likes: 0, comments: 0,
      tags: _selectedTags.toList(),
      hasImage: _hasPhoto,
      postType: _postType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: AppBottomSheet(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('새 게시글 작성',
            style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 16),

          Text('글 타입', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brownMid)),
          const SizedBox(height: 8),
          Row(children: _postTypes.map((e) {
            final (key, icon, label) = e;
            final isSelected = _postType == key;
            final color = postTypeColor(key);
            return Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => setState(() { _postType = key; _selectedTags.clear(); }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.12) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? color : Colors.transparent, width: 1.5),
                  ),
                  child: Column(children: [
                    Text(icon, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(label, style: GoogleFonts.notoSansKr(
                      fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? color : AppColors.brownMid)),
                  ]),
                ),
              ),
            ));
          }).toList()),
          const SizedBox(height: 16),

          Text('제목', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brownMid)),
          const SizedBox(height: 6),
          ListenableBuilder(
            listenable: _titleCtrl,
            builder: (_, __) => TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(hintText: '제목을 입력하세요'),
            ),
          ),
          const SizedBox(height: 14),

          Text('태그 선택', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brownMid)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: _tagOptions.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) _selectedTags.remove(tag);
                else _selectedTags.add(tag);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.peach : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tag, style: GoogleFonts.notoSansKr(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.brownMid)),
              ),
            );
          }).toList()),
          const SizedBox(height: 14),

          Text('내용', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brownMid)),
          const SizedBox(height: 6),
          ListenableBuilder(
            listenable: _contentCtrl,
            builder: (_, __) => TextField(
              controller: _contentCtrl, maxLines: 4,
              decoration: const InputDecoration(hintText: '곱슬 케어 팁, 제품 후기, 고민을 자유롭게 나눠봐요!'),
            ),
          ),
          const SizedBox(height: 14),

          GestureDetector(
            onTap: () => setState(() => _hasPhoto = !_hasPhoto),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _hasPhoto ? AppColors.tealLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _hasPhoto ? AppColors.teal : Colors.transparent),
                ),
                child: const Center(child: Text('📸', style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 10),
              Text(_hasPhoto ? '사진 첨부됨 (선택)' : '사진 추가 (선택)',
                style: GoogleFonts.notoSansKr(fontSize: 13, color: _hasPhoto ? AppColors.teal : AppColors.brownLight,
                  fontWeight: _hasPhoto ? FontWeight.w600 : FontWeight.w400)),
            ]),
          ),
          const SizedBox(height: 8),
        ]))),
        ListenableBuilder(
          listenable: Listenable.merge([_titleCtrl, _contentCtrl]),
          builder: (_, __) => Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.peach),
                  foregroundColor: AppColors.peachDark,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('취소', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700)),
              )),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: ElevatedButton(
                onPressed: _canPost ? _submit : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                ),
                child: Text('게시하기', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: Colors.white)),
              )),
            ]),
          ),
        ),
      ]),
    ));
  }
}
