extension DatabaseBool on bool {
  int get toDatabase => this ? 1 : 0;
}

bool boolFromDatabaseResult(int number) {
  if (number != 0 && number != 1) {
    throw Exception("can only parse from 0 or 1");
  }

  return number == 1;
}
