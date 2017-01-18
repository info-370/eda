# Health Burden

To practice performing exploratory data analysis, you'll conduct an investigation of a dataset from the [Global Burden of Disease Study](http://www.healthdata.org/gbd). The data was downloaded from this [web tool](http://ghdx.healthdata.org/gbd-results-tool) with this specific [configuration](http://ghdx.healthdata.org/gbd-results-tool?params=querytool-permalink/691e5f887d1df5b76b46f9d1ed315b5d).

Additional data downloaded from:

- [Population Data](http://ghdx.healthdata.org/record/global-burden-disease-study-2015-gbd-2015-population-estimates-1970-2015)
- [Location hierarchy](http://ghdx.healthdata.org/record/global-burden-disease-study-2015-gbd-2015-location-hierarchies)

The dataset describes the death rate (deaths per 100K people) _attributable to_ five different risk factors:

- Smoking
- Low physical activity
- High red-meat consumption
- Drug use
- Alcohol use

Note, these estimates vary by:

- **Country**: 195 countries, each with a specific region / super-region
- **Sex**: Reported as male/female
- **Age-group**: Groups include: Under 5, 5 - 14, 15 - 49, 50 - 69, 70+

To begin working with this dataset, open up the `eda.R` file, or run `jupyter notebook` in your terminal, and begin working in the `eda.ipynb` file to answer the following questions:

## Data Structure
To get a basic sense of your dataset, check the following:

- How large is the dataset (rows, columns)?
- What are the variables present in the dataset?
- What is the data type of each variable?

## Univariate Analysis
For each variable of interest, answer the following questions. As you do so, begin making a list of further questions you would like to investigate:

- What does the distribution of each (risk factor) variable look like?
- Is any variable ever missing (and if so, why)?
- What are the basic summary statistics (mean, median, standard deviation) each variable, and what is it's range (min/max)?
- What do you find surprising?

This [resource](http://www.statmethods.net/graphs/boxplot.html) may help for making boxplots/violin plots in R.

## Univariate analysis (by age)
In this section, you should investigate how each (risk-variable) varies by **age group**. More specifically, consider if the distribution of each variable of interest (smoking, alcohol use, etc.) is consistent across age-groups.

## Univariate analysis (by sex)
In this section, you should investigate how each (risk-variable) varies by **sex group**. More specifically, consider if the distribution of each variable of interest (smoking, alcohol use, etc.) is consistent across sex-groups. Depending on your procedure, you may need to **reshape your data**.

## Univariate analysis (by country)
In this section, you should investigate how each (risk-variable) varies by **country**. Given the number of countries present in the dataset, I suggest that you aggregate your data by region. In order to do this, you'll need to **convert death rates to deaths** using the `pop` column.

## Bivariate analysis
In this section, you should compare risks-variables to one another to see how they co-vary. Use simple statistical tests (i.e., **correlation**) and visualization as you see fit. 
