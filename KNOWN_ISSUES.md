# Known issues

These projects are university coursework, kept close to how they were submitted. A line-by-line
review in October 2026 found the problems below. They are **not fixed** because fixing them would
change the reported results, and the saved notebook outputs and written conclusions were part of
the graded work. Treat the numbers as a snapshot of what was learned at the time.

R scripts could not be run during the review, so those findings come from reading the code.

## Python notebooks

**Bike Rentals Predictions**
- Several features (`Higher_Demand`, `Low_Humidity`, `Warmth`, `Popular_Day`, `Best_Rent_T`) are built from the rentals of all labelled rows, including rows later used as the test set. The test scores are therefore too optimistic.
- About two thirds of the timestamps are at :59, so the extracted hour is one hour early. Rounding to the nearest hour would fix it.
- The hyperparameter searches (commented out) were fit on train plus test rows, and the scaler and some medians are computed before the train/test split.

**Low Birthweight Prediction Algorithms**
- `roc_auc_score` is given 0/1 predictions instead of predicted probabilities, so the reported AUC values are not true AUCs.
- The class weight `{0: 5, 1: 1}` boosts the majority class. The intended `{0: 1, 1: 5}` is defined but never passed to the model.
- One row has `monpre = 0` and `npvis = 0`, so the feature `p_c_i` is NaN, and a later `dropna` silently removes the whole column.
- The confusion matrices used to rank the models mix train and test rows. The scaler is fit before the split.

**Facebook Unsupervised ML**
- `roc_auc_score` is given 0/1 predictions here as well.
- Model 1 includes the row ID `status_id` as a feature. Clusters are fit before the train/test split.
- The cluster names in `cluster_names` look attached to the wrong clusters (the saved centroids suggest 0 = Pragmatists, 1 = Young_Minds, 2 = Politically_Active, 3 = Leads). K-means labels can change between runs, so check against the centroids after any re-run.
- The four cluster summaries all print the centroid of cluster 0.
- The summary text says Model 3 is best, but the saved outputs show Models 1 and 2 are better on several measures. The text also names generations and brands, which the data (posts only) cannot show.

**Feature Engineering**
- The printed table row labelled "Basement" actually counts fireplaces.

**Wedding Database Analysis (business question)**
- `vendor_rating == 0` means "missing", but it is removed only in one later cell, so the earlier correlations use it. The price-rating correlation is +0.06 with the zeros and -0.09 without them.
- The sustainable vendors are concentrated in a few departments (venues, catering, photo and video), so the price gap between sustainable and non-sustainable vendors is mostly a department effect. The conclusion that sustainable vendors are "not more cost-effective" is not supported as written.
- Some regression text has the direction wrong (the model predicts rating from sustainability). One heatmap is titled "Diamond Features" by mistake.

## R scripts

**Bank Churn Prediction:** `sensitivity()` and `specificity()` are called with the arguments in the wrong order, so the printed values (and the comments based on them) describe the wrong class. Always predicting "no churn" would score about 78.8% accuracy, which is the baseline for the quoted 83.4%.

**MoneyBall Substitutes:** the data has no pitching table, so the "closer" statistics (ERA, innings pitched) are computed from batting columns. The players chosen as closers are position players. The outfielder ranking has no minimum at-bats, so players with 1 to 7 at-bats rank first. `head(ranked_closers)` returns 6 rows, not 10.

**Airbnb Data Mining & Analysis**
- The description column is renamed by position (`[5]`), which may be a different column.
- Word triples (`n=3`) are split into two words, so the results labelled bigrams are wrong.
- Topic modelling treats every word as its own document, so the topics are not meaningful.
- The "rating by word" charts count each listing once per word occurrence.
- The Shiny dashboard cannot run on its own: it uses objects that only exist in the main script.
