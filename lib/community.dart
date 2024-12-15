import 'package:flutter/material.dart';
import 'example_post.dart'; // 예시 데이터 임포트
import 'post.dart'; // Post 모델 임포트

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '질문 게시판'),
            Tab(text: '약사 게시판'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          QuestionBoard(),
          PharmacistBoard(),
        ],
      ),
    );
  }
}

class QuestionBoard extends StatelessWidget {
  const QuestionBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // 질문 게시판 데이터만 필터링
    final List<Post> posts = questionBoardPosts;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post),
              ),
            );
          },
        );
      },
    );
  }
}

class PharmacistBoard extends StatelessWidget {
  const PharmacistBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // 약사 게시판 데이터만 필터링
    final List<Post> posts = pharmacistBoardPosts;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post),
              ),
            );
          },
        );
      },
    );
  }
}

// 게시글 상세 화면
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 및 작성일
            Text(
              '작성자: ${post.author}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '작성일: ${post.dateTime}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // 게시물 내용
            Text(
              post.content,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 16),
            // 이미지 (선택적)
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
