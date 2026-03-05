import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

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
                onTap: () => setState(() => _filter = f),
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
        // Search bar
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
                if (filtered.isEmpty) {
                  return _emptyState();
                }
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
        // Post type badge at top-left
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

        // Author row
        Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
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

        // Title
        if (post.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(post.title,
              style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
          ),

        Text(post.content, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.6)),

        if (post.hasImage) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity, height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.peachLight, AppColors.tealLight]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('📸', style: TextStyle(fontSize: 36))),
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
            label: '${post.likes + (widget.liked && !post.isPinned ? 0 : 0)}',
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

// --------------- Post Form ---------------

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
    final options = <String>[...curlTypeTags.map((t) => t)];
    if (_postType == 'salon') options.addAll(_regionTags);
    if (_postType == 'product') options.addAll(_productTags);
    return options;
  }

  List<String> get curlTypeTags => _curlTypeTags;

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
    return AppBottomSheet(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('새 게시글 작성',
            style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 16),

          // Post type selector
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

          // Title
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

          // Tags
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

          // Content
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

          // Photo toggle
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
          const SizedBox(height: 20),

          // Buttons
          ListenableBuilder(
            listenable: Listenable.merge([_titleCtrl, _contentCtrl]),
            builder: (_, __) => Row(children: [
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
        ]),
      ),
    );
  }
}
