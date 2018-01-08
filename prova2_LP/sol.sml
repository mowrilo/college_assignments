fun mywhl 0 acc _ = acc
 |  mywhl n acc cmd = cmd (mywhl (n-1) acc cmd);

fun nthPower n = mywhl n 1 (fn x => x * n);

fun fact n =
  if n > 0
  then mywhl (n-1) 1 (fn x => x * (x+1))
  else 1
  ;
