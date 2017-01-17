# Health Burden

To practice performing exploratory data analysis, you'll conduct an investigation of a dataset from the [Global Burden of Disease Study](). The data was downloaded from this [web tool]() with this specific [configuration](http://ghdx.healthdata.org/gbd-results-tool?params=querytool-permalink/691e5f887d1df5b76b46f9d1ed315b5d).

The dataset describes the burden due to the **disability** of living with certain diseases, as well as the **life lost** due to mortality. More specifically, it has the following metrics for 10 chosen diseases. The dataset includes the number/rate/percentage for specific age/sex categories in each country in 2015.

- **Deaths**: The number of deaths from a given disease.
- **Years of life lost (YLLs)**: The number of years of life lost due to the disease (given how long an individual in an age group _should have lived_)
- **Years lived with disability (YLDs)**: The amount of disability experienced due to a disease, calculated based on the number of people living with the disease, and how bad it is to have that disease.
- **Disability Adjusted Life Years (DALYs)**: The burden experience from premature mortality and years lived with disability. The simple sum of YLLs and YLDs.

Note, these estimates vary by:

- **Country**: 189 countries, each with a specific region / super-region
- **Sex**: Calculated as male/female
- **Age-group**: Groups include Under 5, 5 - 14, 15 - 49, 50 - 69, 70+

To begin working with this dataset, open up the `eda.R` file, or run `jupyter notebook` in your terminal, and begin working in the `eda.ipynb` file to answer the following questions:

## Data Structure
To get a basic sense of your dataset, check the following:

- How large is the dataset (rows, columns)?
- What are the variables present in the dataset?
- What is the data type of each variable?

## Univariate Analysis
For each variable of interest, answer the following questions. As you do so, begin making a list of further questions you would like to investigate:

- What is the distribution of each variable?
- Is each variable ever missing (and if so, why)?
- What are the basic summary statistics (mean, median, standard deviation) each variable, and what is it's range (min/max)?

This [resource](http://www.statmethods.net/graphs/boxplot.html) may help for boxplots/violin plots.

## Univariate (in depth)

- Is the distribution of your variable of interest (deaths, dalys, etc.) consistent across groupings (sex/age)?
