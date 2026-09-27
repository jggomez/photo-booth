import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/presentation/utils/social_share_service.dart';

void main() {
  group('SocialShareService Tests', () {
    test('provides DevFest Quito 2026 default hashtag and caption', () {
      expect(SocialShareService.officialHashtag, equals('#devfestquito26'));
      expect(
        SocialShareService.shareCaption,
        contains('#devfestquito26'),
      );
      expect(
        SocialShareService.shareCaption,
        contains('DevFest Quito 2026'),
      );
    });
  });
}
