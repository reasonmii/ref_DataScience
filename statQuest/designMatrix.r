#########################
# First Example
#########################

Type <- factor(c(
  rep("Control", times=4),
  rep("Mutant", times=4)
))

# Weights for the control mice
# followed by the weights for the mutant mice
Weight <- c(2.4, 3.5, 4.4, 4.9, 1.7, 2.8, 3.2, 3.9)

# Size for the control mice
# followed by the size for the mutant mice
Size <- c(1.9, 3, 2.9, 3.7, 2.8, 3.3, 3.9, 4.8)

# Construct a design matrix
# y : size
# x : type, weight
model.matrix(~Type+Weight)

# first column -> control intercept
# second column -> mutant offset
# last column -> slope

model <- lm(Size~Type+Weight)
summary(model)


#########################
# Second Example
#########################

Lab <- factor (c(
  rep("A", times=6),
  rep("B", times=6)
))

# Control data
Type <- factor(c(
  rep("Control", times=3), # Lab A
  rep("Mutant", times=3),  # Lab A
  rep("Control", times=3), # Lab B
  rep("Mutant", times=3)   # Lab B
))

Expression <- c(
  1.7, 2, 2.2,
  3.1, 3.6, 3.9,
  0.9, 1.2, 1.9,
  1.8, 2.2, 2.9
)

# See the design matrix
# We don't have to specify the control mean
# because that is done by default
model.matrix(~Lab+Type)

# First column : multiplied by 'lab A control mean'
# Second column -> multiplied by 'lab B offset'
#                  only "on" when the data is generated by lab B
# last column -> multiplied by the difference between
#                the mean of the mutant data
#                and the mean of the control data
  
batch.lm <- lm(Expression ~ Lab + Type)
summary(batch.lm)
