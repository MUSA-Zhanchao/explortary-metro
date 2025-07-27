# Metro Line comparison in Bogota
[![Software License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**Author**: Zhanchao Yang, Chuwen Zhong

Summer 2025

# Introduction & Research Questions

Bogotá, long served by an extensive bus network yet plagued by chronic congestion and air pollution, is on the cusp of a major transit transformation. The city’s first metro lines—Line 1, which will link the northwest suburbs with the city center, and Line 2, running through the northern corridor—promise not only faster, more reliable journeys but also substantial environmental and socio-economic benefits. However, the success of this infrastructure depends as much on engineering and finance as on public buy-in, which encompasses how citizens perceive its effectiveness, its impact on air quality and noise, and its broader effects on livelihoods and equity.

This study examines how the near subway line household perception differs between Line 1 and Line 2, and how socio-economic factors influence their perception

By illuminating the perceptions held by various communities, we aim to inform both policy adjustments and communication strategies that will maximize public support and ensure that Bogotá’s metro delivers on its promise of cleaner, more equitable urban mobility.

# Method
## Sampling and Participants
This study employs a cross-sectional survey design to compare household perceptions and socio-economic profiles along Bogotá Metro Line 1 (elevated) and Line 2 (underground). A total of 537 households were collected, with 290 completed responses for Line 1 and 247 for Line 2 (response rates of 72.5% and 61.8%, respectively).


## Data Processing and Analysis
- **Data Cleaning**: Responses were exported to R, where invalid entries were removed and categorical variables were standardized (e.g., income brackets).
- **Descriptive Statistics**: Frequencies and percentages were calculated for all variables by corridor.
- **Comparative Analysis**: Chi-square tests assessed significant differences in categorical responses between Line 1 and Line 2 households. （*potential next steps*)
- **Visualization**: Bar charts and cross-tabulations were generated to illustrate key contrasts.

All analyses were performed in R version 4.3.3, using packages `dplyr`, `ggplot2`.

## Bivariate Analysis

### Purpose

The purpose of the bivariate analysis in this study is to:

- **Explore associations** between pairs of variables from the Bogotá Metro survey, such as:
  - Public perception of the Metro vs housing characteristics
  - Housing tenure vs commuting behavior
  - Income vs willingness to pay for Metro fare
  - Current transportation mode vs willingness to adopt Metro

- **Test hypotheses** such as:
  - Renters are more optimistic about the Metro than owners.
  - Renters prefer living near mass transit to reduce commute time.
  - Higher-income households are more willing to pay higher fares.
  - Current transit users are more likely to use the Metro.

- **Inform regression modeling** by:
  - Revealing trends and potential predictor-outcome relationships
  - Identifying sparse or small cell sizes that may require category collapsing
  - Assessing whether data meet assumptions for regression models

### Specific Method

The analysis uses **cross-tabulation (contingency tables)** to show how the values of one variable are distributed across another. Specifically, the methods include:

- **Frequency and percentage tables** for each relationship
- **Stratification by Metro Line** (Line 1 and Line 2) to compare geographic differences
- **Descriptive summaries** of associations and patterns in the tables

These methods are **non-parametric and exploratory**, serving as a foundation for the proposed regression models, such as:

- Ordinal logistic regression (e.g., perception or willingness as outcomes)
- Binary logistic regression (e.g., willingness to use the Metro: yes/no)
- Multinomial logistic regression (if the proportional-odds assumption is violated)


## Unsupervised clustering for Sample and Metro non-supporters

- Primary targeted question (Metro Perception): P87-P101
- Demographic integrated perception question

## clustering method
- Latent Classic analysis and clustering
- K-means clustering
- Hierarchical clustering

# [Exploratory Results](https://github.com/zyang91/explortary-metro/blob/main/report/Results.md)

The Results section presents a comparative overview of demographic profiles, travel behaviors, perception metrics, and implementation expectations among households adjacent to Metro Line 1 and Line 2. We begin by summarizing general socio‑demographic characteristics before exploring shifts in travel modes pre‑ and during the pandemic. Next, we examine attitudes toward the upcoming metro service—covering efficiency, safety, and environmental perceptions—followed by anticipated community impacts post‑implementation.

**See the detailed results at [results.md](https://github.com/zyang91/explortary-metro/blob/main/report/Results.md)**


## Exploratory Results Key Takeaway

### Pre- and During-Pandemic Travel Modes
- **Bicycle use**: Before COVID-19, 13.8% of Metro 2 commuters biked versus 7.3% for Metro 1; during the pandemic, this rose to 15.8% (Metro 2) vs. 9.3% (Metro 1)
- **Walking**: Metro 1 saw higher walking rates during the pandemic (19.7%) compared to Metro 2 (10.5%)

### Socio-economic profiles
- **Income distributions**: Metro 1 has a higher share of respondents in the top income bracket of 2.5 – 3.5 million (16.5% vs. 9.0%), whereas Metro 2 peaks in the mid-range bracket of 1.16 – 1.5 million (24.2% vs. 15.5%)

### Perceptions and Attitudes
- **Quick and efficient**: A larger share of Metro 1 respondents felt the system would be quick and efficient (62.6%) versus Metro 2 (53.4%)
- **Optimism vs pessimism**: “Very optimistic” ratings were more common in Metro 1 (34.9%) than Metro 2 (23.5%), while Metro 2 had more “Very pessimistic” responses (13.8% vs. 5.9%)
- **Overall support**: Support for the project was higher in Metro 1 (93.8%) than in Metro 2 (89.1%)
- **Preference for other modes**: Metro 2 users were somewhat more inclined to choose other transport options (70.4%) compared to Metro 1 (66.1%)
- **Most important factors in travel**: Metro 2 pays more attention to **Punctuality of buses** (20% vs. 10%), while Metro 1 focuses more on **time of trips, comfort during trips, and cost of the trips**.
- **Optimism and support**: Metro 1 users are more optimistic about the metro system than Metro 2 households, and Metro 1 shows stronger support for the system's construction.

### Information and Awareness
In general, information availability is low for both Metro One and Metro Two households. People are not sure of the infrastructure type, metro route, station location, and estimated year of operations. People are more willing to pay a lower price to ride the system.

- **Access to information**: Metro 1 respondents reported slightly better awareness of infrastructure details (13.2% “A lot of information” vs. 10.9%)

### After implementing perception
There is no statistically significant difference in implementation perception between Metro 1 and Metro 2 households.

### Summary
These patterns suggest that Metro 1 respondents tend to be more optimistic, better informed, and perceive greater benefits (efficiency, support) from the new line, while Metro 2 respondents—many of whom own their homes and live in larger households—exhibit higher cycling rates, greater concern for punctuality and security, and slightly less overall enthusiasm.

# [Bivariate Analysis Results](https://github.com/zyang91/explortary-metro/blob/main/report/bivariable.md)

We explore four bivariable relationships, summarize them in a table, and recommend whether each should proceed to regression analysis along with the most appropriate model type.

- Relationship 1: public perception vs housing characteristics
- Relationship 2: Impact of Metro Project on Housing Rents
- Relationship 3: Income vs Willingness to Pay
- Relationship 4: Willingness to use vs transportation for work

## Key takeaway
The bivariate analysis of the Bogotá Metro survey reveals meaningful relationships between residents' perceptions, socioeconomic characteristics, and transportation behaviors. Optimism toward the Metro project is more common among renters, shorter-term residents, and lower-rent households, suggesting that more mobile and transit-reliant populations are more supportive. Renters, especially along Line 2, are more likely to live closer to mass transit and walk to work, indicating location preferences that reduce commute times. Income is positively associated with willingness to pay for Metro fares, though nonresponse and sparse high-income cells limit precision. Finally, current transit and pedestrian commuters show the strongest willingness to adopt the Metro, while private and active-mode users are more hesitant. These insights inform the design of suitable regression models and informed policy recommendations.

# [Non-support portrait](https://github.com/zyang91/explortary-metro/blob/main/report/non-support-portrait.md)
![Layout](https://github.com/user-attachments/assets/4f755e08-97f7-4762-88ea-05405bc70f8b)

## Key takeaway
Non-supporters of the Bogotá Metro project are predominantly renters (69%), long-term residents, and solo householders, with a strong reliance on BRT and SITP systems. Despite being public transport users, they express widespread dissatisfaction with current services, citing concerns over punctuality, safety, and comfort. Their top priorities in transportation are safety and travel time, yet most expect the Metro to increase housing costs, living expenses, and construction-related commute times. A large majority (84%) are only willing to pay the lowest fare tier, and over half plan to walk to future Metro stations. Overall, the profile suggests that non-supporters are cost-conscious, safety-oriented, and skeptical of public infrastructure improvements, highlighting the need for targeted communication and design strategies that address affordability, accessibility, and trust in service reliability.

# Unsupervised Cluster for Non-supporters

Wait

# Unsupervised Cluster for all samples
