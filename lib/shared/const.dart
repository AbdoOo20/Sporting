import 'package:news/models/authenticate/user%20model.dart';

import '../models/other/banner model.dart';
import '../models/other/setting model.dart';
import '../models/statistics/articles.dart';
import '../models/statistics/player.dart';

List arabic = [
  'ظ',
  'ز',
  'و',
  'ة',
  'آ',
  'ى',
  'لآ',
  'لا',
  'ر',
  'ؤ',
  'ء',
  'ئ',
  'لأ',
  'لإ',
  'إ',
  'أ',
  'ط',
  'ك',
  'م',
  'ن',
  'ت',
  'ا',
  'ل',
  'ب',
  'ي',
  'س',
  'ش',
  'ض',
  'ص',
  'ث',
  'ق',
  'ف',
  'غ',
  'ع',
  'ه',
  'خ',
  'ح',
  'ج',
  'د',
  'ذ',
];

List<ArticlesModel> articles = [];
List<ArticlesModel> otherArticles = [];
List<PlayerModel> players = [];
List<PlayerModel> otherPlayers = [];
List<BannerModel> upBanners = [];
List<BannerModel> downBanners = [];
late UserModel userModel;
SettingModel settingModel = SettingModel(
  id: 0,
  newsTicker: '',
  intellectualProperty: '',
  membershipTerms: '',
  privacyPolicy: '',
  evacuationResponsibilaty: '',
  vision: '',
  userCount: 0,
  visitors: 0,
  value: '',
  whatsNumber: '',
);




