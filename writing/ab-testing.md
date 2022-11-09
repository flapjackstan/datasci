# AB Testing

Explain (in at most two sentences per part):

a) The article uses an acronym (that is actually the name of an animal).  What, according to the article, does this acronym stand for and what does it have to do with A/B testing?

HiPPO - Highest paid persons opinion.

In the context of A/B testing, the A/B testing system helps mitigate the issue where the HiPPO pushes their ideas through and neglects all possible ideas. A/B testing rather experiments all possible solution the team has and quantifies results leading to better decision making. 

b) What, according to the article, is a downside of A/B testing?

Accoding to the article, one of the downsides to A/B testing is that it is a bigger lift to do a complete restructure of a website or system and rather narrows updates to singular component changes. In short, people will want to pick and test certain component changes and test rather than make large changes. Tiny changes > Large Changes.

Suppose you do an A/B test where your goal is to increase customer time spent on your website, and you are testing whether a new font helps.  You randomly assign the next 200 visitors to your site to the two different options.

a) Describe how you can use a regression model to determine whether the font has a significant effect on time spent on the website.  Be sure to describe what your "x" and "y" variables are here and what p-value you would look at to do the test.

time_spent_on_page ~ dummy_font_new

dummy_font_new: a binary variable of the new font being tested (current font will be associated to the intercept). 
time_spent_on_page: a numerical variable that is the time spent someone spent on the page.

I would look at the p-value dummy_font_new and see if there is statistical significance that the observations labeled with the new font is associated with increased/decreased time spent. I would also look at the model p-value and compare it with industry norms to see if our model r2 falls in expectation of similar models.


b) You know that the age of a customer is highly related to the amount of time spent on the website (young customers spend a lot of time on there!).  Thus you are worried that if by chance a lot of young people were randomly assigned to the new font, then perhaps you could be fooled into thinking the effect you were seeing in part (a) was due to the difference in font when in fact it was just due to one font happening to get more of the young people than the other.  Describe how you can use a regression model to conduct the A/B test while accounting for this problem with age.  You do have access to the age of your customers.  As in the previous part, describe what your "x" and "y" are and what p-value you would look at to do the A/B test to determine whether the new font leads to more time on the site.

time_spent_on_page ~ age * dummy_font_new

dummy_font_new: a binary variable of the new font being tested (current font will be associated to the intercept).
age: a numerical variable that is the age of the person viewing the site
time_spent_on_page: a numerical variable that is the time spent someone spent on the page.

I would look at the p-values for the age interacting with font and font itself in the interactions model to determine if the font is associated with increased/decreased difference keeping age constant. I would also look at the p-value for the model as explained above. 



