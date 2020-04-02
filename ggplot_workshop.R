# ggplot2 Workshop, Arkansas State University
# presented by Alix Matthews, A-State R User Group via Zoom
# 6 April 2020




#### Install packages, load libraries, examine data ####
# TIP: Use at least 4 dashes, pounds, or equal signs after a comment to create a code section

# Install some general packages
install.packages(c("dplyr","devtools","ggplot2","ggthemes","RColorBrewer","gridExtra","gapminder","pacman","reshape2"))

# Load pacman to make loading other packages in your library much quicker
library(pacman)

# Use p_load to load multiple libraries at once (otherwise, have to load each library separately)
# i.e., library(dplyr)
#       library(ggplot2)
#       etc...
p_load(dplyr, devtools, ggplot2, ggthemes, RColorBrewer, gridExtra, gapminder, reshape2)


# Let's look at the structure of some pre-loaded R dataframes to understand what we will be plotting today
str(gapminder)
str(iris)
str(mpg)

# Can view the dataframes also
# Two different ways
#### 1
head(gapminder) # first 6 lines
tail(iris) # last 6 lines
#### 2
View(mpg) # as a table




#### Base R graphics ####
# Cheatsheet here: http://publish.illinois.edu/johnrgallagher/files/2015/10/BaseGraphicsCheatsheet.pdf

# Make a quick, simple plot using base R graphics
# plot(y~x, df)
boxplot(lifeExp~continent, gapminder)
plot(Petal.Width~Petal.Length, iris)

# Let's see how to quickly modify base R graphics using the above plots as a starting point
# Notice how every new addition is separated by a comma
boxplot(lifeExp~continent, gapminder,
        col = "gray",
        main = "Base Plot 1",
        xlab = "Continent",
        ylab = "Life Expectancy"
        )

plot(Petal.Width~Petal.Length, iris,
     type = "p", # "p" for points, "l" for lines, "b" for both, others
     pch = 6, # plot character; many options here (1-25)
     col = "blue", # character color
     main = "Base Plot 2",
     xlab = "Petal Length",
     ylab = "Petal Width"
     )




#### Base R: Skipping this for the workshop, but leaving in case someone is interested ####

# You *can* plot by species in base R, but takes some maneuvering
# First, specify your colors (in alphabetical order) and make sure to specify that your category is a factor
iris_colors <- c("darkgreen", "darkorange", "darkmagenta")[as.factor(iris$Species)]

# Then add your plot with a new "col" argument
plot(Petal.Width~Petal.Length, iris,
     type = "p",
     pch = 6,
     col = iris_colors,
     main = "Base Plot 2",
     xlab = "Petal Length",
     ylab = "Petal Width"
)

# # Then add your legend
legend("topleft", legend = unique(iris$Species), col = c("darkgreen", "darkorange", "darkmagenta"), pch = 6)

# Fit a simple regression line to be added to figure
model<- lm(Petal.Width~Petal.Length, iris)

# Add the regresion line
abline(model, lwd = 4, col="purple") # lwd is line width; col is color of line




#### ggplot2 graphics ####
# Cheatsheet here: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# gg in ggplot stands for "the grammar of graphics"

# Make a quick, simple plot using ggplot2
# ggplot requires a few things (the basics)...
# 1. State you want to make a ggplot
# 2. Define dataframe (df)
# 3. Define aesthetics (which tells ggplot how variables in the df are to be displayed on the plot - these are your df column names)
##### These are important and can be a little confusing
##### If you want to use something directly from the data, put it inside aes ("mapping" aes)
##### If you want to set something to the data, put it outside of aes ("setting" aes)
# 4. Define the geometry of the plot (what kind of plot)
# NOTES:
##### The "+" sign in ggplot is to combine layers
##### Layers are stacked in the order of code appearance

ggplot(gapminder, aes(x = continent, y = lifeExp)) +
    geom_boxplot()

ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
    geom_point()


# Let's see how to quickly modify ggplot2 graphics using the above plots as a starting point
# Start with gapminder data

# "Map" color (automatic colors) using the data, by continent
# Let's also give the plot an object name so we don't have to keep copying and pasting

gg1 <- ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) +
    geom_boxplot() # for fun, change "fill" to "color" and see what happens

# Check it out first
gg1

# Let's "set" a color to the data just to compare
ggplot(gapminder, aes(x = continent, y = lifeExp)) +
    geom_boxplot(fill = "darkgreen")
# for fun, see what happens when you instead use: geom_boxplot(aes(fill = "darkgreen"))
# you are mapping something (the term "darkgreen") to every row in the dataframe, causing them all to be the same color and to display like it is

# Now edit axis and main titles (layers added on top of the previous plot, which we named "gg1")
# Remove the legend (all within "theme" - "theming" edits parts of the graphic that are not directly linked to the data)
gg1 +
    xlab("Continent") +
    ylab("Life Expectancy") +
    ggtitle("ggplot 1") +
    theme(plot.title = element_text(color = "blue", size = 20),
          axis.title.x = element_text(size = 12, face = "bold"),
          axis.title.y = element_text(size = 12, face = "italic"),
          legend.position = "none")



#### ggplot2: Skipping this for the workshop, but leaving in case someone is interested ####

# But let's say you do want a legend, and you want to change the title of the legend, as well as manually edit the colors
gg2 <-
     ggplot(gapminder, aes(x = continent, y = lifeExp, fill = continent)) +
         geom_boxplot() +
         scale_fill_manual(values=c("green", "blue", "yellow", "purple", "red"),
                               name = "CONTINENT") + # specify your colors and change legend title here since you are manually editing the colors
         xlab("Continent") +
         ylab("Life Expectancy") +
         ggtitle("ggplot2") +
         theme(axis.title = element_text(size = 11, face = "bold"))  # covers both x and y axis titles

# Check it out
gg2

# Change the background theme for fun. FYI, this overrides other theme properties if placed at the very end (can override this by putting theme_clean() before other theme properties - remember, these are layers upon layers in ggplot)
gg2 +
     theme_clean() # see tab-complete for other options




# Let's move to the iris dataset
# Start with the basics, then add our axis titles and change point shape
ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
    geom_point(shape = 6) +
    xlab("Petal Length") +
    ylab("Petal Width")

# Change our point colors; two different ways will produce the same plot visually, but will have some underlying differences... so visualizing the differences will be impt to understand the regression line(s) in a minute
# Let's give them each an object name to simplify things

# "Setting" within geom_point (per layer) will draw regression across all points
gg_layer_aes <-
    ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
        geom_point(shape = 6, aes(col = Species)) +
        scale_color_manual(values = c("versicolor" = "darkorange", "setosa" = "darkgreen", "virginica" = "darkmagenta")) +
        xlab("Petal Length") +
        ylab("Petal Width") +
        ggtitle("gg layer aes") +
        theme(legend.text = element_text(face = "italic"))

# Take a look
gg_layer_aes

# "Mapping" in global aesthetics will give each "group" a regression line
gg_global_aes <-
    ggplot(iris, aes(x = Petal.Length, y = Petal.Width, col = Species)) + # if you didn't care about colors, could just use "group = Species"
        geom_point(shape = 6) +
        scale_color_manual(values = c("versicolor" = "darkorange", "setosa" = "darkgreen", "virginica" = "darkmagenta")) +
        xlab("Petal Length") +
        ylab("Petal Width") +
        ggtitle("gg global aes") +
        theme(legend.text = element_text(face = "italic"))

# Take a look, should look identical to above, but we will see the differences below
gg_global_aes

# Add regression line(s)
gg_layer_aes +
    geom_smooth(method = "lm")

# Can change size, color, confidence interval level, and CI shading color
gg_layer_aes +
    geom_smooth(method = "lm", size = 0.5, col = "black", fill = "purple", level = 0.99)

# Regression by species due to where we specified color
gg_global_aes +
    geom_smooth(method = "lm", level = 0.85)


#### ggplot2 extras (facets, other plots, color palettes, themes) ####
# Faceting
# facet_grid(vertical~horizontal)
#### a "." indicates to "facet by nothing" on the certain grid
gg_global_aes +
    geom_smooth(method = "lm", level = 0.85) +
    facet_grid(.~Species, scales = "fixed") + # see "free" too
    theme(strip.text = element_text(face = "italic"),
          legend.position = "none")


# Different types of plots
# Density; alpha is related to the transparency of the color
ggplot(gapminder, aes(x = lifeExp)) +
    geom_density(aes(fill = continent), alpha = 0.25)

# Histogram; bins are how many groups the data are parsed into
ggplot(gapminder, aes(x = lifeExp)) +
    geom_histogram(aes(fill=continent), bins = 40)

# Bar plots
# stat = "count" is default, so it just counts whatever you pass to it (and you can leave blank)
# position = "stack" is default also
ggplot(mpg, aes(x = class, fill = manufacturer)) +
    geom_bar() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Color palettes and themes
# Beyoncé, https://github.com/dill/beyonce
devtools::install_github("dill/beyonce")
library(beyonce)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
    geom_point(size = 3) +
    scale_color_manual(values = beyonce_palette(9)) +
    theme_clean() # see tab-complete for others

# Wes Anderson, https://github.com/karthik/wesanderson
devtools::install_github("karthik/wesanderson")
library(wesanderson)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
    geom_point(size = 3) +
    scale_color_manual(values = wes_palette("GrandBudapest1")) +
    theme_fivethirtyeight()

# RColorBrewer, https://rdrr.io/cran/RColorBrewer/man/ColorBrewer.html
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
    geom_point(size = 3) +
    scale_color_brewer(palette = "Dark2",
                       name = "Iris Species") +
    theme_bw() +
    theme(legend.text = element_text(face = "italic"))




#### Last thing if time allows ####
# Some data manipulation to iris dataset from wide to long format, using the Species column as the identifier... for visualization purposes... could be impt for you if you have your data organized in wide format and you need to "melt" to long format for plotting
iris2 <- melt(iris, id = "Species")
head(iris2) # long format
head(iris) # wide format, just to see comparison

# stat = "identity" means it is taking the #s you provide through your df (in this case, we made a new column called "variable" with our melt, and we are passing this info directly to geom_bar)
# position = "dodge" means they are next to one another
ggplot(iris2, aes(x=Species, y=value, fill=variable)) +
    geom_bar(stat="identity", position="dodge") +
    scale_fill_manual(values=c("Sepal.Length" = "darkorange", "Sepal.Width" = "purple4", "Petal.Length" = "darkgreen", "Petal.Width" = "darkblue"),
                      name="Iris\nMeasurements",
                      labels=c("Sepal Length", "Sepal Width", "Petal Length", "Petal Width")) +
    theme(axis.text.x = element_text(face = "italic"))
