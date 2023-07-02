
## two variables, one discrete, one continouse

base3 <- ggplot(diamonds, aes(x=cut, y=price)) 

base3 + 
  geom_boxplot(col="yellow", size=0.5)

## ggplot2
library(ggplot2)

# carat vs price
base4 <- ggplot(diamonds, aes(carat, price, col=cut))

#point chart
base4 + 
  geom_point() +
  theme_minimal() + 
  scale_color_brewer(type = "div", palette = 3)

# check price with qplot

p1 <- qplot(x=price, data=diamonds, geom="histogram", bins=10)

# qplot with carat vs price
#independent variable => x 
#dependent variable => y

p2 <- qplot(x=carat, y=price, data=diamonds,geom="point")

#plot grade diamonds with bar chart
p3 <- qplot(x=cut, data=diamonds,geom="bar")


#lables
ggplot(diamonds, aes(carat, price)) + 
  geom_point() + 
  theme_minimal() + 
  labs(
    title = "My scatter plot",
    subtitle = "Practice work with R!",
    X = "Carat",
    Y = "Price",
    caption = "Source: R Studio"
  )

#








  





