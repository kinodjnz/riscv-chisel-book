package common

object OptionExtension {
  def map2[A, B, C](fa: Option[A], fb: Option[B])(f: (A, B) => C): Option[C] =
    for { a <- fa; b <- fb } yield f(a, b)
}
