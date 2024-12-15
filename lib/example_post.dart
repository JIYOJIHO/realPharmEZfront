import 'post.dart';

/// Example posts for the Q&A board
final List<Post> questionBoardPosts = [
  Post(
    id: '1',
    title: '손을 다쳤는데',
    content: '손을 다쳤는데 피가 안 멈춰요 ㅠㅠ 어떻게 해야 할까요?',
    author: '팜백마',
    timestamp: '10/22 23:15',
    dateTime: '', // 예제 이미지 URL (선택 사항)
  ),
  Post(
    id: '2',
    title: '강아지 산책 꿀팁 좀 주세요',
    content: '처음 키우는 강아지인데 산책 어떻게 해야 할지 모르겠어요.',
    author: '멍멍이집사',
    timestamp: '10/15 14:22', dateTime: '',
  ),
  Post(
    id: '3',
    title: '중고 노트북 사도 괜찮을까요?',
    content: '학생인데 새 노트북은 너무 비싸서 중고를 고민 중이에요. 어떤 점을 조심해야 하나요?',
    author: '학생A',
    timestamp: '10/10 09:45', dateTime: '',
  ),
  Post(
    id: '4',
    title: '운동 루틴 조언 부탁드려요',
    content: '근력 운동을 하고 싶은데 하루 30분 루틴으로 추천해 주실 수 있나요?',
    author: '헬스초보',
    timestamp: '11/01 19:30', dateTime: '',
  ),
  Post(
    id: '5',
    title: '요즘 독서할 책 추천해주세요',
    content: '요즘 뭘 읽을지 모르겠어요. 감명 깊었던 책 있으면 알려주세요!',
    author: '북덕후',
    timestamp: '11/03 17:05', dateTime: '',
  ),
];
//
// 약사 게시판 데이터 추가
final List<Post> pharmacistBoardPosts = [
  Post(
    id: '100',
    title: '시험기간, 오랜 렌즈 착용으로 눈이 건조하다면?',
    content: '안녕하세요! 요즘 시험기간이라 그런지 대학생',
    author: '약사 1',
    timestamp: '2024-11-20', dateTime: '',
  ),
  Post(
    id: '101',
    title: '성인 여드름 자국, 흉지기 전에 얼른 보세요!',
    content: '약사가 알려주는 약국템 완벽 정리 해드 ...',
    author: '약사 2',
    timestamp: '2024-11-19', dateTime: '',
  ),
  Post(
    id: '102',
    title: '면봉으로 점막을 닦으면 안되는 이유',
    content: '최근 한 방송에서 면봉에 안약을 뭍힌 후 ...',
    author: '약사 3',
    timestamp: '2024-11-18', dateTime: '',
  ),
];
