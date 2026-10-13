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
  i.e. $C$ is closed under convex combination.
]

#note[Examples of Convex Sets][
  - $emptyset$, $RR^n$, points, lines, line segments, rays
  - hyperplane $P = {x in RR^n : w^T x = b}$
  - halfspace $H = {x in RR^n : w^T x <= b}$
]

#proposition[Set Intersection Preserves Convexity][

  The intersection of an arbitrary collection of convex sets is convex.
]

#note[Examples of Convex Sets][
  - affine space $S = {x in RR^n: A x = b}$
  - polyhedron $P = {x in RR^n: A x <= b}$ or more generally ${x in RR^n: A x <= b, C x = d}$
]

#proposition[Norm Balls Are Convex][

  A closed ball $overline(B) (x_0, r) = {x in RR^n : norm(x - x_0) <= r}$ is convex.
]

#proof[][
  $
    norm((theta x_1 + overline(theta) x_2) - x_0) & = norm(theta(x_1 - x_0) + overline(theta)(x_2 - x_0)) \
                                                  & <= norm(theta(x_1 - x_0)) + norm(overline(theta)(x_2 - x_0)) \
                                                  & <= theta r + overline(theta) r \
                                                  & = r
  $
]

#note[][
  True for any norm $norm(dot)$.
]

#note[][
  Open balls are also convex.
]

#proposition[Ellipsoids Are Convex][

  An ellipsoid $cal(E) = {x_0 + A u: norm(u)_2 <= 1}, A in RR^(n times n), A succ O$ is convex.
]

#proof[][
  Using affine transformation preserves convexity, $cal(E)$ is convex.
]
#note[][Often written as $cal(E) = {x: (x - x_0)^T P^(-1) (x-x_0) <= 1}, P = A A^T succ 0$]

#proposition[Affine Transformation Preserves Convexity][

  If $C$ is convex, then $f(C)$ is convex.
]

#proof[][

  Affine transformation satisfies
  $ f(theta x_1 + overline(theta) x_2) = theta f(x_1) + overline(theta) f(x_2) $
  $ x_1, x_2 in C => theta x_1 + overline(theta) x_2 in C $
  $
    theta y_1 + overline(theta) y_2 & = theta f(x_1) + overline(theta) f(x_2) \
                                    & = f(theta x_1 + overline(theta) x_2) in f(C)
  $
]
#proposition[Affine Transformation Preserves Convexity][

  If $C$ is convex, then $f^(-1) (C)$ is convex.
]

#proof[][

  Affine transformation satisfies
  $ f(theta x_1 + overline(theta) x_2) = theta f(x_1) + overline(theta) f(x_2) $
  $ y_1, y_2 in C => theta y_1 + overline(theta) y_2 in C $
  $
    f(theta x_1 + overline(theta) x_2) & = theta f(x_1) + overline(theta) f(x_2) \
                                       & = theta y_1 + overline(theta) y_2 in C
  $
  $ theta x_1 + overline(theta) x_2 in f^(-1) (C) $

]

#definition[Convex Combination][
  $ sum_(i=1)^m theta_i x_i = theta_1 x_1 + theta_2 x_2 + dots + theta_m x_m $
  where $theta_i >= 0$ and $sum_(i=1)^m theta_i = 1$
]

#theorem[][

  If $C$ is convex, and $x_i in C$, then any convex combination $sum_(i=1)^m theta_i x_i in C$
]

#proof[][

  $y_1 = x_1$
  $ y_k = sigma_(k-1) / sigma_k y_(k-1) + theta_k / sigma_k x_k, k>= 2 $
  where
  $ sigma_k = sum_(i=1)^k theta_i $
  Note
  $ y_m = sum_(i=1)^m theta_i x_i $
]
#definition[Convex Hull][

  The convex hull of a set $S subset RR^n$, denoted $"conv" S$, is the smallest convex set containing $S$, i.e.
  + $S subset "conv" S$
  + $"conv" S$ is convex
  + If $S subset S^'$ and $S^'$ is convex, then $"conv" S subset S^'$
]

#theorem[][

  $"conv" S$ is the set of all convex combinations of points in $S$, i.e.
  $ "conv" S = {sum_(i=1)^m theta_i x_i: m in NN; x_i in S; theta_i >=0; sum_(i=1)^m theta_i = 1} $
]
#proof[][

  + Let $m=1$. Trivial.
  + $
      theta x + overline(theta) x^' = theta sum_(i=1)^m theta_i x_i + overline(theta) sum_(i=1)^n theta_i^' x_i^' = sum_(i=1)^m theta theta_i x_i + sum_(i=1)^n overline(theta) theta_i^' x_i^'
    $
    where $ sum_(i=1)^m theta theta_i + sum_(i=1)^n overline(theta) theta_i^' = 1 $
  + If $S subset S^'$ and $S^'$ is convex,

    $forall x in "conv" S$, $x = sum_(i=1)^m theta_i x_i$

    Since $x_i in S subset S^'$, $S^'$ is convex, thus

    $x = sum_(i=1)^m theta_i x_i in S^'$

    $"conv" S subset S^'$
]

#definition[Affinely Independent Points][

  $m+1$ points $x_0, x_1, dots, x_m in RR^n$ are affinely independent if $x_1 - x_0, dots, x_m - x_0$ are linearly independent.
]

#proposition[][

  $x_0, x_1, dots, x_m in RR^n$ are affinely independent iff
  $ sum_(i=0)^m c_i x_i = 0 "and" sum_(i=0)^m c_i = 0 => c_i = 0 $
]

#note[][

  In $RR^n$, the maximum number of affinely independent is $n+1$.
]

#definition[Simplex][

  An m-simplex is the convex hull of $m+1$ affinely independent points.
  $ "conv"{x_0, dots, x_m} = {theta_0 x_0 + dots + theta_m x_m: theta >=0, 1^T theta = 1} $
]

#definition[Examples of Simplexes][
  - Probability n-simplex in $RR^(n+1)$
    $ Delta_n = {theta in RR^(n+1): theta >= 0, 1^T theta = 1} $
  - Unit n-simplex in $RR^n$
    $ Delta_n^' = {theta^' in RR^(n): theta^' >= 0, 1^T theta^' <= 1} $
]

#definition[Cone][

  A set $C$ is a cone if $x in C, theta >=0 => theta x in C$
]


#proposition[][

  A set $C$ is a convex cone iff
  $ x_1, x_2 in C, theta_1, theta_2 >=0 => theta_1 x_1 + theta_2 x_2 in C $
  i.e. $C$ is closed under conic combination.
]

#proof[][

  $C$ is a convex cone $=>$ closed under conic combination
  $
    theta_1 x_1 + theta_2 x_2 = (theta_1 + theta_2)(theta_1 / (theta_1 + theta_2) x_1 + theta_2 / (theta_1 + theta_2) x_2)
  $
  $
    x_1, x_2 in C &=>^("convexity") theta_1 / (theta_1 + theta_2) x_1 + theta_2 / (theta_1 + theta_2) x_2 in C \ &=>^("conic") (theta_1 + theta_2)(theta_1 / (theta_1 + theta_2) x_1 + theta_2 / (theta_1 + theta_2) x_2) in C
  $

  Closed under conic combination $=>$ $C$ is a convex cone

  Trivial.
]

#definition[Conic Hull][

  The conic hull of a set $S$, denoted $"cone"(S)$, is the smallest convex cone containing $S$.
  + $S subset "cone" S$
  + $"cone" S$ is a convex cone
  + If $S subset S^'$ and $S^'$ is a convex cone, then $"cone" S subset S^'$
]

#proposition[][

  $"cone"(S)$ is the set of all conic combinations of points in $S$, i.e.
  $ "cone"(S) = {sum_(i=1)^m theta_i x_i: m in NN; x_i in S; theta_i >= 0} $
]
== Projection & Separation
All norms are Euclidean norm in this section.
#definition[Point-Set Distance][

  Given a set $C subset RR^n$, the distance between a point $x$ and $C$ is
  $ "dist"(x, C) = inf_(z in C) norm(x - z) $
]
#theorem[][

  If $C subset RR^n$ is nonempty, closed and convex, then for any $x$, there is a unique $hat(x) in C$ s.t.
  $ "dist"(x, C) = norm(x - hat(x)) $
  $hat(x)$ is called the projection of $x$ onto $C$ and denoted by $hat(x) = cal(P)_C (x)$
]

#proof[][

  First show existence.

  Let $z_0 in C$. Then $"dist"(x, C) <= norm(x - z_0)$

  $ K = {z in C: norm(x - z) <= norm(x - z_0)} = C inter overline(B)(x, norm(x - z_0)) $
  $norm(x - z)$ is continuous (1-Lipschitz continuous) in $K$, $K$ compact $=>$ Existence of minimizer.

  Then show uniqueness.

  Suppose $hat(x)_1, hat(x)_2 in C$ satisfy $"dist"(x, C) = norm(x - hat(x)_1) = norm(x - hat(x)_2)$

  $hat(x)_c = (hat(x)_1 + hat(x)_2)/2 in C$ by convexity
  $ norm(x - hat(x)_c) >= "dist"(x, C) $
  Using the identity
  $ norm(y + z)^2 + norm(y - z)^2 = 2 norm(y)^2 + 2 norm(z)^2 $
  $
    norm(hat(x)_1 - hat(x)_2)^2 & = 2 norm(x - hat(x)_1)^2 + 2 norm(x - hat(x)_2)^2
                                  - norm(2x - (hat(x)_1 + hat(x)_2))^2 \
                                & = 4 "dist"(x, C)^2 - 4 norm(x - x_c)^2 <= 0
  $
  $ hat(x)_1 = hat(x)_2 $
]
#note[][
  $ cal(P)_C (x) = x <=> x in C $
]

#proposition[][

  Let $C subset RR^n$ be nonempty, closed and convex. Given $hat(x) in C, hat(x) = cal(P)_C (x)$ iff
  $ chevron(x-hat(x)"," z - hat(x)) <= 0, forall z in C $
]
#proof[][
  #intuition[][Introduce $t$ to make $norm(z - hat(x))^2$ a higher-order term as $t->0$.]
  Note $hat(x) + t(z - hat(x)) in C$, $forall z in C, t in [0, 1]$.

  $
    hat(x) = cal(P)_C (x) & <=> norm(x - hat(x) - t(z - hat(x)))^2 >= norm(x - hat(x))^2,
                            quad forall z in C, t in [0, 1] \
                          & <=> -2t chevron(x - hat(x)"," z - hat(x))
                            + t^2 norm(z - hat(x))^2 >= 0,
                            quad forall z in C, t in [0, 1] \
                          & <=> chevron(x - hat(x)"," z - hat(x)) <= 0,
                            quad forall z in C
  $
]
#proof[][

  $hat(x)$ is the minimizer of $f(z) = 1/2 norm(z - x)^2$

  Using the first-order necessary conditions for constrained problems,

  $d^T nabla f(hat(x)) >= 0$ for any feasible direction $d$ at $hat(x)$.
  Let $d = z - hat(x)$
  $ nabla f(z) = z - x $
  $ (z - hat(x))^T (hat(x) - x)) >= 0 $
  $ chevron(x-hat(x)"," z - hat(x)) <= 0, forall z in C $
]
#corollary[Nonexpansiveness of Projection][

  The projection operator is nonexpansive, i.e.

  $ norm(cal(P)_C (x) - cal(P)_C (y)) <= norm(x - y) $
]
#proof[][

  Let $hat(x) = cal(P)_C (x)$, $hat(y) = cal(P)_C (y)$.

  $
    norm(x - y)^2 & = norm(hat(x) - hat(y))^2
                    + norm(x - y - (hat(x) - hat(y)))^2
                    + 2 chevron(x - y - (hat(x) - hat(y))"," hat(x) - hat(y)) \
                  & >= norm(hat(x) - hat(y))^2
                    - 2 underbrace(chevron(y - hat(y)"," hat(x) - hat(y)), <= 0)
                    - 2 underbrace(chevron(x - hat(x)"," hat(y) - hat(x)), <= 0) \
                  & >= norm(hat(x) - hat(y))^2
  $
]

#corollary[][

  Let $C subset RR^n$ be nonempty, closed and convex. For $x_0 in.not C$, there exists a  $w in RR^n \\ {0}$ s.t.
  $ sup_(x in C) chevron(w"," x)<chevron(w"," x_0) $
]

#proof[][

  Let $hat(x)_0 = cal(P)_C (x_0)$ and $w = x_0 - hat(x)_0$.
  Since $x_0 in.not C$ and $hat(x)_0 in C$, $w != 0$.


  $
    chevron(w"," x - hat(x)_0) <= 0
  $

  Thus,

  $
    chevron(w"," x)
    <= chevron(w"," hat(x)_0)
    = chevron(w"," x_0) - chevron(w"," w)
  $

  Taking supremum over $C$,

  $
    sup_(x in C) chevron(w"," x)
    <= chevron(w"," x_0) - chevron(w"," w)
    < chevron(w"," x_0)
  $
]


#definition[Boundary][
  $ partial C = overline(C) \\ "int" C $

]

#theorem[Supporting Hyperplane Theorem][

  If $C$ is nonempty, convex set in $RR^n$ and $x_0 in partial C$, then there exists $w in RR^n \\ {0}$ s.t.
  $ chevron(w"," x) <= chevron(w"," x_0), forall x in C $
  $P = {x: w^T x = w^T x_0}$ is called a supporting hyperplane to $C$ at $x_0$
]
#proof[][
  #lemma[][If $C$ is convex, then $"int" C = "int" overline(C), partial C = partial overline(C)$]
  $x_0 in partial C => x_0 in partial overline(C)$

  $exists {x_k} "s.t." x_k in.not overline(C), x_k -> x_0 "as" k -> infinity$

  $exists w_k != 0$ s.t.$chevron(w_k"," x) < chevron(w_k"," x_k), forall x in C$

  By, rescaling, we can assume $norm(w_k) = 1$

  Since ${w_k}$ is bounded after normalization, by the Bolzano-Weierstrass Theorem, ${w_k}$ has a convergent subsequence $w_k_i -> w$.



  $ chevron(w_k_i"," x) < chevron(w_k_i"," x_k_i), forall x in C $
  Take $i -> infinity$
  $ chevron(w"," x) <= chevron(w"," x_0), forall x in C $
]

#theorem[Separating Hyperplane Theorem][

  If $C_1, C_2$ are nonempty, convex sets in $RR^n$ with $C_1 inter C_2 = emptyset$, then $C_1$ and $C_2$ can be separated by a hyperplane, i.e. $exists w in RR^n \\ {0}, b in RR$ s.t.
  $ w^T x <= b, forall x in C_1 $
  $ w^T x >= b, forall x in C_2 $
  $P={x: w^T x = b}$ is called a separating hyperplane for $C_1$ and $C_2$.
]

#proof[][
  #lemma[][If $C_1, C_2$ are two nonempty convex sets s.t. $C_1 inter C_2 = emptyset$, then $C = C_1 - C_2 = {x_1 - x_2: x_1 in C_1, x_2 in C_2}$ is a nonempty convex set and $0 in.not C$
  ]

  We only need to show that $exists w != 0$ w.t.
  $ w^T x_1 <= w^T x_2, forall x_1 in C_1, x_2 in C_2 $
  Then we can take $ b = sup_(x_1 in C_1) w^T x_1 in RR $
  Let $C = C_1 - C_2$. The above inequality is equivalent to
  $ chevron(w"," x) <= 0, forall x in C $

]
