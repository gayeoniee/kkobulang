import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

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

  final _filters = ['전체', '2A','2B','2C','3A','3B','3C','4A','4B','4C'];

  @override
  void initState() {
    super.initState();
    _posts = List.from(communityPosts);
  }

  List<CommunityPost> get _filtered =>
    _filter == '전체' ? _posts : _posts.where((p) => p.curlType == _filter).toList();

  void _toggleLike(int id) {
    setState(() {
      final post = _posts.firstWhere((p) => p.id == id);
      if (_liked.contains(id)) {
        _liked.remove(id);
        post.likes--;
      } else {
        _liked.add(id);
        post.likes++;
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
              child: const Text('글 쓰기 ✏️'),
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
                  child: Text(f == '전체' ? '🌿 전체' : f,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.white : AppColors.brownMid)),
                ),
              );
            },
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '게시글, 태그 검색...',
              prefixIcon: Icon(Icons.search, color: AppColors.brownLight),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: filtered.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('💬', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('아직 글이 없어요', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
              ]))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _PostCard(
                  post: filtered[i],
                  liked: _liked.contains(filtered[i].id),
                  onLike: () => _toggleLike(filtered[i].id),
                ),
              ),
        ),
      ]),
    );
  }
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
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
            child: Center(child: Text(post.avatar, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 8),
          Expanded(child: Row(children: [
            Text(post.author, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brown)),
            const SizedBox(width: 6),
            CurlTypeBadge(post.curlType),
          ])),
          Text(post.time, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        ]),
        const SizedBox(height: 10),

        Text(post.content, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brown, height: 1.6)),

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

        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6,
          children: post.tags.map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Text('#$t', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownMid)),
          )).toList()),

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

class _PostForm extends StatefulWidget {
  final String curlType;
  final void Function(CommunityPost) onSave;
  const _PostForm({required this.curlType, required this.onSave});
  @override
  State<_PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<_PostForm> {
  final _ctrl = TextEditingController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('새 게시글 작성 ✍️',
            style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
              child: const Center(child: Text('😊', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('나', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.brown)),
              CurlTypeBadge(widget.curlType),
            ]),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: _ctrl, maxLines: 5,
            decoration: const InputDecoration(hintText: '곱슬 케어 팁, 제품 후기, 고민을 자유롭게 나눠봐요! 🌿'),
          ),
          const SizedBox(height: 20),
          Row(children: [
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
            Expanded(flex: 2, child: ListenableBuilder(
              listenable: _ctrl,
              builder: (_, __) => ElevatedButton(
                onPressed: _ctrl.text.trim().isNotEmpty ? () => widget.onSave(CommunityPost(
                  id: DateTime.now().millisecondsSinceEpoch,
                  author: '나', avatar: '😊',
                  curlType: widget.curlType, time: '방금 전',
                  content: _ctrl.text.trim(), likes: 0, comments: 0, tags: [], hasImage: false,
                )) : null,
                child: Text('게시하기 🌸', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            )),
          ]),
        ]),
      ),
    );
  }
}
