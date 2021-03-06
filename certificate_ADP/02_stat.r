#=====================================
# 사칙연산 : + - * / 
#
# 특수연산
# %/% : 나눗셈 몫
# %% : 나눗셈 나머지
# %*% : 행렬의 곱
#
# 비교 : ==, != <, <=, >, >=
# 논리부정 : ! ex) !(3==5)
# 논리 and, or : & |
# 
# 기초통계
# head(data명)
# head(data명, n)
# summary(data명)
# 평균 mean(data$column), mean(변수)
# 합계 sum(변수)
# 중앙값 median(data$column), median(변수)
# 분위수 quantile(data$column)
# 로그 log(변수)
# 표준편차 sd(변수)
# 분산 var(변수)
# 공분산 cov(변수1, 변수2)
# 상관계수 cor(변수1, 변수2)
# 변수길이 length(변수)
#
# 식 formula : ~ ex) lm(log(brain)~log(body),data=Animals)
#=====================================

# 수열
1:5                               # 1 2 3 4 5
9:-2                              # 9  8  7  6  5  4  3  2  1  0 -1 -2
seq(from=0, to=20, by=2)          # 0  2  4  6  8 10 12 14 16 18 20
seq(from=0, to=20, length.out=5)  # 0  5 10 15 20

# 지수
5^2     # 25
