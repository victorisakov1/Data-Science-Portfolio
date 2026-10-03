# University Data Science Projects

> **University coursework.** Every project here was built as coursework during my studies at Hult
> International Business School (mostly the Master of Science in Business Analytics). They show
> what I learned at the time, not production code.

Data science, machine learning and SQL projects by Victor Isakov. Each folder is a self-contained
project with its code and data.

## About me

I'm a data and operations analyst who builds AI agents, automations and analytics that help teams
make better decisions. I work as a data and operations associate in consulting. Before that I
co-founded Casey AI, a career intelligence startup, built and backtested trading algorithms as a
quantitative strategist at AlgoForce, and led data analytics and AI adoption at the EdTech company
3 Amigos. I hold an M.S. in Finance and an M.S. in Business Analytics from Hult International
Business School. I work mainly in Python, SQL and R, and build with Claude Code, Codex and
Antigravity.

I'm passionate about the world of investments, operations, analytics, and putting AI to work in
real businesses. Outside of work, I make music in FL Studio (I majored in piano), and I love cars
and a good adventure. I also represented Canada in a competitive team sport at the World
Championships.

[LinkedIn](https://www.linkedin.com/in/victor-isakov) · [GitHub](https://github.com/victorisakov1)

## Projects

| Folder | What it does | Tools |
|---|---|---|
| `Airbnb Data Mining & Analysis/` | Text mining and NLP on Airbnb listings and reviews, with a Shiny dashboard | R, MongoDB |
| `Bank Churn Prediction/` | Predicts which bank customers are likely to leave | R |
| `Bike Rentals Predictions/` | Predicts bike rentals in Chicago with regression, decision tree and KNN models | Python, scikit-learn |
| `Dynamic Team Intro/` | A fill-in-the-blanks game that introduces a team | Python |
| `Facebook Unsupervised ML/` | Groups Facebook Live posts with PCA and k-means clustering | Python, scikit-learn |
| `Feature Engineering/` | Feature engineering to predict house prices on the Ames Housing dataset | Python, scikit-learn |
| `Kolobok Fairytale/` | A text adventure game based on the Russian fairytale Kolobok | Python |
| `Low Birthweight Prediction Algorithms/` | Classification models that predict low birthweight | Python, scikit-learn |
| `MoneyBall Substitutes/` | Finds affordable replacement players, Moneyball style | R |
| `Wedding Database Analysis/` | Tests whether sustainable wedding vendors are more cost-effective | SQL, Python |
| `Wedding Database Business Challenge I/` | Builds wedding budget options from the vendor database | SQL, Python |

## Getting started

**Python notebooks:** install Python 3.10 or newer, then:

```bash
pip install -r requirements.txt
jupyter notebook
```

Open a notebook from inside its folder, since each one reads its data with a relative path.

**R scripts:** open the script in RStudio, set the working directory to the script's folder, and
install the packages it loads with `install.packages()`. The Airbnb script needs a MongoDB Atlas
cluster with the sample data loaded; put its connection URL in a `MONGO_URL` environment variable.

**SQL:** the wedding scripts are written for MySQL. Run `FY_Wedding_DB_Code.sql` first to create
the database.

## Data and license

The code is licensed under the [Apache License 2.0](LICENSE). The datasets belong to their original
sources and keep their own terms. For example, the baseball data is from the Lahman Baseball
Database (CC BY-SA 3.0, see `MoneyBall Substitutes/readme2013.txt`).
