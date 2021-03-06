
# 날짜 변환
Sys.Date()  # "2022-02-10"
# as.Date()
format(Sys.Date(), format="%m/%d/%y")  # "02/10/22"

# 날짜 조회
format(Sys.Date(), '%a')  # 목
format(Sys.Date(), '%b')  # 2
format(Sys.Date(), '%B')  # 2월
format(Sys.Date(), '%d')  # 10
format(Sys.Date(), '%m')  # 02
format(Sys.Date(), '%y')  # 22
format(Sys.Date(), '%Y')  # 2022

# 날짜 일부 추출
d <- as.Date("2021-12-25")
p <- as.POSIXlt(d)   # "2021-12-25 UTC"
p$yday               # 358

start <- as.Date("2021-12-01")
end <- as.Date("2021-12-25")
seq(from=start,to=end,by=1)

