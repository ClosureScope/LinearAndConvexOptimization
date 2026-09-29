#set text(lang: "zh", region: "cn")
#import "template.typ": *
#set text(font: (font-en, font-song))
#show strong: set text(font: (font-en, font-hei), weight: "regular")
#show emph: text.with(font: (font-en, font-kai), style: "normal")
#show: frame-style(styles.hint)
#show: ilm.with(
  title: [线性优化与凸优化],
  author: "Closure",
  figure-index: (enabled: true),
)

= Introduction
== Linear Least Squares Regression
$ min_(w in RR^n, b in RR) sum_(i=1)^m (x_i^T w + b - y_i)^2 = min_(w in RR^n, b in RR) norm(X w + b - y)^2 $
== Binary Classification
$ cases(f(x_i) > 0 "iff" y_i = 1, f(x_i) < 0 "iff" y_i = -1) <=> y_i f(x_i) > 0 $
=== Logistic Regression
$ p (y | x) = sigma(y f(x)) = sigma(y(w^T x + b)) $
$ sigma(z) = 1 / (1 + e^(-z)) $
$ max_(w,b) L(w, b) = product_(i=1)^m p(y_i | x_i) $
$ min_(w,b) "NLL"(w, b) = - log L(w, b) = sum_(i=1)^m log(1 + e^(-y_i (x_i^T w + b))) $
=== Support Vector Machine
Assume data is linearly separable, i.e. exists hyperplane $w^T x + b = 0$ s.t. $ y_i (w^T x_i + b) > 0, forall i $
- distance from $x_i$ to $P$
$ "dist"(x_i, P) = abs(w^T x_i + b) / norm(w) $
- margin
$ min_(1 <=i <=m) abs(w^T x_i + b) / norm(w) $
- SVM
$ max_(w, b) min_(1<=i<=m) abs(w^T x_i + b) / norm(w) $
$ y_i (w^T x_i + b) > 0 $
Not easy to solve in this form.

Problem equivalent to
$ min_(tilde(w), tilde(b)) 1/2 norm(tilde(w))^2 $
$ y_i (tilde(w)^T x_i + tilde(b)) >= 1 $

#proof[][
  $ max_(w, b) min_(1<=i<=m) abs(w^T x_i + b) / norm(w) = max_(w, b) (min_(1<=i<=m) abs(w^T x_i + b)) / norm(w) $

  Try to get rid of $min_(1<=i<=m) abs(w^T x_i + b) = min_(1<=i<=m) y_i (w^T x_i + b)$

  For $alpha > 0$, $tilde(w) = alpha w$ and $tilde(b) = alpha b$ determine the same hyperplane $P$

  Choosing $alpha$ properly, we can assume $min_(1<=i<=m) y_i (tilde(w)^T x_i + tilde(b)) = 1$

  Note that now $y_i (tilde(w)^T x_i + tilde(b)) > 0$ is redundant

  Also note that $max_(tilde(w),tilde(b)) 1/norm(w)$ is equivalent to $min_(tilde(w), tilde(b)) 1/2 norm(tilde(w))^2$

  The problem is thus equivalent to problem $P_1$:

  $ min_(w,b) 1/2 norm(tilde(w))^2 $
  $ Omega_1: min_(1<=i<=m) y_i (tilde(w)^T x_i + tilde(b)) = 1 $

  We now prove $P_1$ is equivalent to $P_2$:
  $ min_(tilde(w), tilde(b)) 1/2 norm(tilde(w))^2 $
  $ Omega_2: y_i (tilde(w)^T x_i + tilde(b)) >= 1 $

  Note that $Omega_1 subset.eq Omega_2$

  We only need to prove $forall (tilde(w), tilde(b)) in Omega_2 \\ Omega_1, (tilde(w), tilde(b))$ must not be optimal in $P_2$

  Suppose $exists (w^*, b^*) in Omega_2 \\ Omega_1, (w^*, b^*)$ is optimal in $P_2$

  $ min_(1<=i<=m) y_i (w^(*T) x_i + b^*) = c > 1 $

  $ w^' = w^* / c, b^' = b^* / c $

  $ min_(1<=i<=m) y_i (w^('T) x_i + b^') = 1 $

  $(w^', b^') in Omega_1$, but $norm(w^') < norm(w^*)$, $(w^', b^')$ is better than $(w^*, b^*)$, contradiction!
]

Hard margin SVM requires linear separability. When not linearly separable, use soft margin SVM
introducing slack variables $xi = (xi_1, dots, xi_n)$
$ min_(w,b,xi) 1/2 norm(w)^2 + C sum_(i=1)^m xi_i $
$ y_i (w^T x_i + b) >= 1 - xi_i $
$ xi >= 0 $
=
== Existence of Solution
#theorem[Extreme Value Theorem][

  If $f$ is continuous on a nonempty compact set $K$, then $f$ attains its maximum
  and minimum on $K$, i.e. there exist $x_1, x_2 in K$ s.t.
  $ f(x_1) <= f(x) <= f(x_2), forall x in K $
]

#corollary[][

  If $f$ if continuous on $RR^n$ and $f(x) -> + infinity$ as $norm(x) -> infinity$, then the global min exists
  i.e. there exists $x^*$ s.t.
  $ f(x^*) <= f(x), forall x $
]

#definition[Coercive][A function $f$ is called coercive if $f(x) -> + infinity$ as $norm(x) -> infinity$]

#definition[Local Minimum][

  $x^* in Omega$ is a local minimum of $f$ on $Omega$ if there exists $epsilon > 0$ s.t.
  $ f(x^*) <= f(x), forall x in Omega inter B(x^*,epsilon) $
  $x^*$ is a strict local minimun if strict inequality holds for $x != x^*$
]
== First-Order Conditions for Unconstrained Problems
#theorem[First-Order Necessary Conditions for Unconstrained Problems][

  If $x^*$ is a local minimum of $f$ and $f$ is differentiable at $x^*$, then its gradient at $x^*$ vanishes, i.e.
  $ nabla f(x^*) = 0 $
]
#proof[][

  Let $d in RR^n, t in RR$
  $ g(t) = f(x^* + t d) $
  $ g(t) >= g(0) => (g(t) - g(0))/t >= 0 => g^' (0) >= 0 => d^T nabla f(x^*) >= 0 $
  Let $d = - nabla f(x^*)$
  $ norm(nabla f(x^*))^2 <= 0 => nabla f(x^*) = 0 $

]
#definition[Stationary Point][

  A point $x^*$ with $nabla f(x^*) = 0$ is called a stationary point of $f$]

#theorem[First-Order Necessary Conditions for Constrained Problems][

  If $x^*$ is in the interior of $Omega$, then $nabla f (x^*) = 0$

  otherwise, $d^T nabla f(x^*) >= 0$ for any feasible direction $d$ at $x^*$
]
== Second-Order Conditions for Unconstrained Problems
#proposition[Rayleigh Quotient][

  $A$ is symmetric, $x != 0$
  $ lambda_min <= (x^T A x) / (x^T x) <= lambda_max $
]
#proof[][
  $ x^T A x = x^T Q Lambda Q^T x = tilde(x)^T Lambda tilde(x) = sum_i lambda_i tilde(x)_i^2 $
]

#theorem[Second-Order Necessary Conditions][

  If $f: RR^n -> RR$ is twice continuously differentiable and $x^*$ is a local minimum of $f$, then
  $ nabla^2 f(x^*) succ.eq 0 $
]
#proof[][
  $ f(x^* + t d) = f(x^*) + t^2/2 d^T nabla^2 f(x^*) d + o(t^2 norm(d)^2) >= f(x^*) $
  $ 1/2 d^T nabla^2 f(x^*) d + o(norm(d)^2) >= 0, t->0 $
  Taking $t->0$ yields $ d^T nabla^2 f (x^*) d >= 0 $
]
#theorem[Second-Order Sufficient Conditions][

  Suppose $f$ is twice continuously differentiable. If
  + $nabla f(x^*) = 0$
  + $nabla^2 f(x^*) succ 0$
  then $x^*$ is a local minimum.
]
#proof[][

  Suppose $d != 0$
  $
    f(x^* + d) & = f(x^*) + 1/2 d^T nabla^2 f(x^*) d + o(norm(d)^2) \
               & >= f(x^*) + 1/2 lambda_min norm(d)^2 - epsilon norm(d)^2 \
               & > f(x^*)
  $

]
#note[][
  The second condition $nabla^2 f(x^*) succ 0$ cannot be replaced by $nabla^2 f(x^*) succ.eq 0$
]
=
== Convex Sets
#note[Lines, Line Segments and Rays][

  Given $x != y in RR^n$
  - line $ theta x + (1 - theta) y, theta in RR $
  - ray $ theta x + (1 - theta) y, theta >= 0 $
  - line segment $ theta x + (1 - theta) y, 0 <= theta <= 1 $
]

#note[][Often use notation $overline(theta) = 1 - theta$]

#definition[Convex Sets][

  A set $C subset RR^n$ is convex if the line segment between any two points $x, y in C$ lies entirely in $C$, i.e.
  $ x in C, y in C, theta in [0, 1] => theta x + overline(theta) y in C $
]

#note[Examples of Convex Sets][
  - $emptyset$, $RR^n$, points, lines, line segments, rays
  - hyperplane $P = {x in RR^n : w^T x = b}$
  - halfspace $H = {x in RR^n : w^T x <= b}$
]

#proposition[][]
