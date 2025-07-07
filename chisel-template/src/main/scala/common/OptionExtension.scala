package common

object OptionExtension {
  def map2[A, B, R](fa: Option[A], fb: Option[B])(f: (A, B) => R): Option[R] =
    for { a <- fa; b <- fb } yield f(a, b)
  def map3[A, B, C, R](fa: Option[A], fb: Option[B], fc: Option[C])(f: (A, B, C) => R): Option[R] =
    for { a <- fa; b <- fb; c <- fc } yield f(a, b, c)
}
