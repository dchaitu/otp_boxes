const int EACH_WORD_LENGTH = 5;
const int CHANCES = 6;

String mainUrl = 'https://jctmglxoe8.execute-api.us-east-1.amazonaws.com/testing';
String get authApiUrl => '$mainUrl/api/token/';
String get wordUrl => '$mainUrl/word/';
String get loginUrl => '$mainUrl/login/';
String get signUpUrl => '$mainUrl/signup';
String get guessedWordUrl => '$mainUrl/guess/';
String get correctWordUrl => '$mainUrl/correct/';
String get jwtTokenUrl => '$mainUrl/api/token/';
String get checkUserUrl => '$mainUrl/check-user';
String get googleLoginUrl => '$mainUrl/google/';