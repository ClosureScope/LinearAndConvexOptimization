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
