{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "0bef5e39",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-11-01T20:08:27.394040Z",
     "iopub.status.busy": "2022-11-01T20:08:27.392449Z",
     "iopub.status.idle": "2022-11-01T20:08:30.164963Z",
     "shell.execute_reply": "2022-11-01T20:08:30.163685Z"
    },
    "papermill": {
     "duration": 2.782914,
     "end_time": "2022-11-01T20:08:30.166838",
     "exception": false,
     "start_time": "2022-11-01T20:08:27.383924",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching packages\u001b[22m ─────────────────────────────────────── tidyverse 1.3.2 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2\u001b[39m 3.3.6      \u001b[32m✔\u001b[39m \u001b[34mpurrr  \u001b[39m 0.3.5 \n",
      "\u001b[32m✔\u001b[39m \u001b[34mtibble \u001b[39m 3.1.8      \u001b[32m✔\u001b[39m \u001b[34mdplyr  \u001b[39m 1.0.10\n",
      "\u001b[32m✔\u001b[39m \u001b[34mtidyr  \u001b[39m 1.2.1      \u001b[32m✔\u001b[39m \u001b[34mstringr\u001b[39m 1.4.1 \n",
      "\u001b[32m✔\u001b[39m \u001b[34mreadr  \u001b[39m 2.1.3      \u001b[32m✔\u001b[39m \u001b[34mforcats\u001b[39m 0.5.2 \n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "Loading required package: Matrix\n",
      "\n",
      "\n",
      "Attaching package: ‘Matrix’\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:tidyr’:\n",
      "\n",
      "    expand, pack, unpack\n",
      "\n",
      "\n",
      "Loaded glmnet 4.1-4\n",
      "\n",
      "Loading required package: lattice\n",
      "\n",
      "\n",
      "Attaching package: ‘caret’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:purrr’:\n",
      "\n",
      "    lift\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:httr’:\n",
      "\n",
      "    progress\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# loading necessary packages\n",
    "library(tidyverse)\n",
    "library(glmnet)\n",
    "library(caret)\n",
    "library(rpart)\n",
    "library(tree)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "902dedea",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:08:30.204108Z",
     "iopub.status.busy": "2022-11-01T20:08:30.181088Z",
     "iopub.status.idle": "2022-11-01T20:10:16.797288Z",
     "shell.execute_reply": "2022-11-01T20:10:16.796071Z"
    },
    "papermill": {
     "duration": 106.632539,
     "end_time": "2022-11-01T20:10:16.805886",
     "exception": false,
     "start_time": "2022-11-01T20:08:30.173347",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 11</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>step</th><th scope=col>type</th><th scope=col>amount</th><th scope=col>nameOrig</th><th scope=col>oldbalanceOrg</th><th scope=col>newbalanceOrig</th><th scope=col>nameDest</th><th scope=col>oldbalanceDest</th><th scope=col>newbalanceDest</th><th scope=col>isFraud</th><th scope=col>isFlaggedFraud</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1</td><td>PAYMENT </td><td> 9839.64</td><td>C1231006815</td><td>170136</td><td>160296.36</td><td>M1979787155</td><td>    0</td><td>0</td><td>0</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1</td><td>PAYMENT </td><td> 1864.28</td><td>C1666544295</td><td> 21249</td><td> 19384.72</td><td>M2044282225</td><td>    0</td><td>0</td><td>0</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1</td><td>TRANSFER</td><td>  181.00</td><td>C1305486145</td><td>   181</td><td>     0.00</td><td>C553264065 </td><td>    0</td><td>0</td><td>1</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>1</td><td>CASH_OUT</td><td>  181.00</td><td>C840083671 </td><td>   181</td><td>     0.00</td><td>C38997010  </td><td>21182</td><td>0</td><td>1</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>5</th><td>1</td><td>PAYMENT </td><td>11668.14</td><td>C2048537720</td><td> 41554</td><td> 29885.86</td><td>M1230701703</td><td>    0</td><td>0</td><td>0</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>6</th><td>1</td><td>PAYMENT </td><td> 7817.71</td><td>C90045638  </td><td> 53860</td><td> 46042.29</td><td>M573487274 </td><td>    0</td><td>0</td><td>0</td><td>0</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 11\n",
       "\\begin{tabular}{r|lllllllllll}\n",
       "  & step & type & amount & nameOrig & oldbalanceOrg & newbalanceOrig & nameDest & oldbalanceDest & newbalanceDest & isFraud & isFlaggedFraud\\\\\n",
       "  & <int> & <chr> & <dbl> & <chr> & <dbl> & <dbl> & <chr> & <dbl> & <dbl> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1 & PAYMENT  &  9839.64 & C1231006815 & 170136 & 160296.36 & M1979787155 &     0 & 0 & 0 & 0\\\\\n",
       "\t2 & 1 & PAYMENT  &  1864.28 & C1666544295 &  21249 &  19384.72 & M2044282225 &     0 & 0 & 0 & 0\\\\\n",
       "\t3 & 1 & TRANSFER &   181.00 & C1305486145 &    181 &      0.00 & C553264065  &     0 & 0 & 1 & 0\\\\\n",
       "\t4 & 1 & CASH\\_OUT &   181.00 & C840083671  &    181 &      0.00 & C38997010   & 21182 & 0 & 1 & 0\\\\\n",
       "\t5 & 1 & PAYMENT  & 11668.14 & C2048537720 &  41554 &  29885.86 & M1230701703 &     0 & 0 & 0 & 0\\\\\n",
       "\t6 & 1 & PAYMENT  &  7817.71 & C90045638   &  53860 &  46042.29 & M573487274  &     0 & 0 & 0 & 0\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 11\n",
       "\n",
       "| <!--/--> | step &lt;int&gt; | type &lt;chr&gt; | amount &lt;dbl&gt; | nameOrig &lt;chr&gt; | oldbalanceOrg &lt;dbl&gt; | newbalanceOrig &lt;dbl&gt; | nameDest &lt;chr&gt; | oldbalanceDest &lt;dbl&gt; | newbalanceDest &lt;dbl&gt; | isFraud &lt;int&gt; | isFlaggedFraud &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | 1 | PAYMENT  |  9839.64 | C1231006815 | 170136 | 160296.36 | M1979787155 |     0 | 0 | 0 | 0 |\n",
       "| 2 | 1 | PAYMENT  |  1864.28 | C1666544295 |  21249 |  19384.72 | M2044282225 |     0 | 0 | 0 | 0 |\n",
       "| 3 | 1 | TRANSFER |   181.00 | C1305486145 |    181 |      0.00 | C553264065  |     0 | 0 | 1 | 0 |\n",
       "| 4 | 1 | CASH_OUT |   181.00 | C840083671  |    181 |      0.00 | C38997010   | 21182 | 0 | 1 | 0 |\n",
       "| 5 | 1 | PAYMENT  | 11668.14 | C2048537720 |  41554 |  29885.86 | M1230701703 |     0 | 0 | 0 | 0 |\n",
       "| 6 | 1 | PAYMENT  |  7817.71 | C90045638   |  53860 |  46042.29 | M573487274  |     0 | 0 | 0 | 0 |\n",
       "\n"
      ],
      "text/plain": [
       "  step type     amount   nameOrig    oldbalanceOrg newbalanceOrig nameDest   \n",
       "1 1    PAYMENT   9839.64 C1231006815 170136        160296.36      M1979787155\n",
       "2 1    PAYMENT   1864.28 C1666544295  21249         19384.72      M2044282225\n",
       "3 1    TRANSFER   181.00 C1305486145    181             0.00      C553264065 \n",
       "4 1    CASH_OUT   181.00 C840083671     181             0.00      C38997010  \n",
       "5 1    PAYMENT  11668.14 C2048537720  41554         29885.86      M1230701703\n",
       "6 1    PAYMENT   7817.71 C90045638    53860         46042.29      M573487274 \n",
       "  oldbalanceDest newbalanceDest isFraud isFlaggedFraud\n",
       "1     0          0              0       0             \n",
       "2     0          0              0       0             \n",
       "3     0          0              1       0             \n",
       "4 21182          0              1       0             \n",
       "5     0          0              0       0             \n",
       "6     0          0              0       0             "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# load the dataset\n",
    "paysim.data <- read.csv('../input/paysim1/PS_20174392719_1491204439457_log.csv')\n",
    "head(paysim.data)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "a35fe961",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:16.821568Z",
     "iopub.status.busy": "2022-11-01T20:10:16.820333Z",
     "iopub.status.idle": "2022-11-01T20:10:22.804643Z",
     "shell.execute_reply": "2022-11-01T20:10:22.803370Z"
    },
    "papermill": {
     "duration": 5.994038,
     "end_time": "2022-11-01T20:10:22.806306",
     "exception": false,
     "start_time": "2022-11-01T20:10:16.812268",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "0"
      ],
      "text/latex": [
       "0"
      ],
      "text/markdown": [
       "0"
      ],
      "text/plain": [
       "[1] 0"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# check missing values\n",
    "sum(is.na(paysim.data))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3bf890ee",
   "metadata": {
    "papermill": {
     "duration": 0.007136,
     "end_time": "2022-11-01T20:10:22.820579",
     "exception": false,
     "start_time": "2022-11-01T20:10:22.813443",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='EDA'></a>\n",
    "#### 2. Exploratory Data Analysis"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e654d45f",
   "metadata": {
    "papermill": {
     "duration": 0.006472,
     "end_time": "2022-11-01T20:10:22.833637",
     "exception": false,
     "start_time": "2022-11-01T20:10:22.827165",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='fraud-trans'></a>\n",
    "##### 2.1. Which types of transactions are fraudulent?\n",
    "We discover that just two of the five different sorts of transactions—TRANSFER, where money is transferred to a customer/fraudster, and \"CASH OUT,\" where money is sent to a business that gives the customer/fraudster cash—involve fraud. (see also kernels by <a href='https://www.kaggle.com/netzone/eda-and-fraud-detection'>Net</a>, <a href='https://www.kaggle.com/philschmidt/where-s-the-money-lebowski'>Philipp Schmidt</a> and <a href='https://www.kaggle.com/ibenoriaki/three-features-with-kneighbors-auc-score-is-0-998'>Ibe_Noriaki</a>): Surprisingly, the amount of forged TRANSFERS is almost equivalent to the amount of forged CASH OUTS. These observations initially seem to support the explanation given on Kaggle for how fraudulent transactions in this dataset are carried out, namely that fraud is carried out by first transferring money to another account, which then cashes it out. We shall return to this issue later in section 2.4"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "2a17d9e9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:22.849232Z",
     "iopub.status.busy": "2022-11-01T20:10:22.848055Z",
     "iopub.status.idle": "2022-11-01T20:10:23.270937Z",
     "shell.execute_reply": "2022-11-01T20:10:23.269772Z"
    },
    "papermill": {
     "duration": 0.432424,
     "end_time": "2022-11-01T20:10:23.272572",
     "exception": false,
     "start_time": "2022-11-01T20:10:22.840148",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 2 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>type</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>TRANSFER</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>CASH_OUT</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 2 × 1\n",
       "\\begin{tabular}{r|l}\n",
       "  & type\\\\\n",
       "  & <chr>\\\\\n",
       "\\hline\n",
       "\t1 & TRANSFER\\\\\n",
       "\t2 & CASH\\_OUT\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 2 × 1\n",
       "\n",
       "| <!--/--> | type &lt;chr&gt; |\n",
       "|---|---|\n",
       "| 1 | TRANSFER |\n",
       "| 2 | CASH_OUT |\n",
       "\n"
      ],
      "text/plain": [
       "  type    \n",
       "1 TRANSFER\n",
       "2 CASH_OUT"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>4097</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 4097\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 4097 |\n",
       "\n"
      ],
      "text/plain": [
       "  n   \n",
       "1 4097"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>4116</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 4116\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 4116 |\n",
       "\n"
      ],
      "text/plain": [
       "  n   \n",
       "1 4116"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# The types of fraudulent transactions\n",
    "fraud.transaction <- paysim.data%>%\n",
    "    filter(isFraud == 1)%>%\n",
    "    distinct(type)\n",
    "head(fraud.transaction)\n",
    "\n",
    "# The number of fraudulent TRANSFERs\n",
    "fraud.transfer <- paysim.data %>%\n",
    "    filter(isFraud ==1 & type == 'TRANSFER')\n",
    "no.fraud.transfer <- fraud.transfer %>%\n",
    "    count()\n",
    "no.fraud.transfer\n",
    "\n",
    "# The number of fraudulent CASH_OUTs\n",
    "fraud.cashout <- paysim.data %>%\n",
    "    filter(isFraud ==1 & type == 'CASH_OUT')\n",
    "no.fraud.cashout <- fraud.cashout %>%\n",
    "    count()\n",
    "no.fraud.cashout"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "55140978",
   "metadata": {
    "papermill": {
     "duration": 0.006929,
     "end_time": "2022-11-01T20:10:23.286694",
     "exception": false,
     "start_time": "2022-11-01T20:10:23.279765",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='isFlaggedFraud'></a>\n",
    "##### 2.2. What determines whether the feature *isFlaggedFraud* gets set or not? \n",
    "Contrary to the description, it turns out that the origin of *isFlaggedFraud* is unknown. There is no apparent correlation between the 16 items (out of 6 million) when the *isFlaggedFraud* attribute is set and any explanatory factor. When an attempt is made to \"TRANSFER\" a \"amount\" more than 200,000, the data is reported as being set as isFlaggedFraud. In reality, even when this need is satisfied, *isFlaggedFraud* can still stay unset, as illustrated below."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "2b208c56",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:23.302914Z",
     "iopub.status.busy": "2022-11-01T20:10:23.301829Z",
     "iopub.status.idle": "2022-11-01T20:10:23.817813Z",
     "shell.execute_reply": "2022-11-01T20:10:23.816675Z"
    },
    "papermill": {
     "duration": 0.525813,
     "end_time": "2022-11-01T20:10:23.819434",
     "exception": false,
     "start_time": "2022-11-01T20:10:23.293621",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>type</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>TRANSFER</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " type\\\\\n",
       " <chr>\\\\\n",
       "\\hline\n",
       "\t TRANSFER\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| type &lt;chr&gt; |\n",
       "|---|\n",
       "| TRANSFER |\n",
       "\n"
      ],
      "text/plain": [
       "  type    \n",
       "1 TRANSFER"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>min.amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>353874.2</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " min.amount\\\\\n",
       " <dbl>\\\\\n",
       "\\hline\n",
       "\t 353874.2\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| min.amount &lt;dbl&gt; |\n",
       "|---|\n",
       "| 353874.2 |\n",
       "\n"
      ],
      "text/plain": [
       "  min.amount\n",
       "1 353874.2  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>max.amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>1e+07</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " max.amount\\\\\n",
       " <dbl>\\\\\n",
       "\\hline\n",
       "\t 1e+07\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| max.amount &lt;dbl&gt; |\n",
       "|---|\n",
       "| 1e+07 |\n",
       "\n"
      ],
      "text/plain": [
       "  max.amount\n",
       "1 1e+07     "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>max.amount</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>92445517</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " max.amount\\\\\n",
       " <dbl>\\\\\n",
       "\\hline\n",
       "\t 92445517\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| max.amount &lt;dbl&gt; |\n",
       "|---|\n",
       "| 92445517 |\n",
       "\n"
      ],
      "text/plain": [
       "  max.amount\n",
       "1 92445517  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# the type of transaction flagged\n",
    "type.flagged.fraud <- paysim.data %>%\n",
    "    filter(isFlaggedFraud == 1) %>%\n",
    "    distinct(type)\n",
    "type.flagged.fraud\n",
    "\n",
    "# Minimum amount for transacted among the flagged transactions\n",
    "min.flagged.amount <- paysim.data %>%\n",
    "    filter(isFlaggedFraud == 1) %>%\n",
    "    summarise(min.amount = min(amount))\n",
    "min.flagged.amount\n",
    "# Minimum amount for transacted among the flagged transactions\n",
    "max.flagged.amount <- paysim.data %>%\n",
    "    filter(isFlaggedFraud == 1) %>%\n",
    "    summarise(max.amount = max(amount))\n",
    "max.flagged.amount\n",
    "\n",
    "# Max amount transacted in a TRANSFER where isFlaggedFraud is not set\n",
    "max.notflagged.amount <- paysim.data %>%\n",
    "    filter(type == 'TRANSFER' & isFlaggedFraud == 0) %>%\n",
    "    summarise(max.amount = max(amount))\n",
    "max.notflagged.amount"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "05ff231b",
   "metadata": {
    "papermill": {
     "duration": 0.007409,
     "end_time": "2022-11-01T20:10:23.834575",
     "exception": false,
     "start_time": "2022-11-01T20:10:23.827166",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Can *isFlaggedFraud* be detected by both *newBalanceDest* and oldBalanceDest? For any TRANSFER where *isFlaggedFraud* is set, the old balance in the origin and destination accounts equals the new balance. This is most likely due to the transaction being stopped <a href='https://www.kaggle.com/lightcc/money-doesn-t-add-up/comments#187011'>[4]</a>. It's interesting to see that *oldBalanceDest* is always equal to 0. However, as illustrated below, these conditions do not affect the status of *isFlaggedFraud* because *isFlaggedFraud* can stay unset in TRANSFERS when *oldBalanceDest* and *newBalanceDest* can both be 0."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "c20f236c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:23.852177Z",
     "iopub.status.busy": "2022-11-01T20:10:23.851127Z",
     "iopub.status.idle": "2022-11-01T20:10:24.629675Z",
     "shell.execute_reply": "2022-11-01T20:10:24.628495Z"
    },
    "papermill": {
     "duration": 0.788787,
     "end_time": "2022-11-01T20:10:24.631263",
     "exception": false,
     "start_time": "2022-11-01T20:10:23.842476",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>4158</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 4158\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 4158 |\n",
       "\n"
      ],
      "text/plain": [
       "  n   \n",
       "1 4158"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# The number of TRANSFERs where isFlaggedFraud = 0, yet oldBalanceDest = 0 and newBalanceDest = 0\n",
    "paysim.data %>%\n",
    "    filter(type == 'TRANSFER' & isFlaggedFraud == 0 & oldbalanceDest == 0 & newbalanceDest == 0) %>%\n",
    "    count()"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c99e51a3",
   "metadata": {
    "papermill": {
     "duration": 0.007529,
     "end_time": "2022-11-01T20:10:24.646476",
     "exception": false,
     "start_time": "2022-11-01T20:10:24.638947",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Since the corresponding range of values overlaps with those for TRANSFERS when *isFlaggedFraud* is not set, *oldBalanceOrig* cannot be thresholded while *isFlaggedFraud* is set (see below). Because *newBalanceOrig* is changed only after the transaction, we do not need to take it into account, whereas *isFlaggedFraud* would be set prior to the transaction."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "ff6a164d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:24.663892Z",
     "iopub.status.busy": "2022-11-01T20:10:24.662849Z",
     "iopub.status.idle": "2022-11-01T20:10:24.909873Z",
     "shell.execute_reply": "2022-11-01T20:10:24.908727Z"
    },
    "papermill": {
     "duration": 0.257729,
     "end_time": "2022-11-01T20:10:24.911803",
     "exception": false,
     "start_time": "2022-11-01T20:10:24.654074",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>min.oldBal.Orig</th><th scope=col>max.oldBal.Orig</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>353874.2</td><td>19585040</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 2\n",
       "\\begin{tabular}{ll}\n",
       " min.oldBal.Orig & max.oldBal.Orig\\\\\n",
       " <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 353874.2 & 19585040\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 2\n",
       "\n",
       "| min.oldBal.Orig &lt;dbl&gt; | max.oldBal.Orig &lt;dbl&gt; |\n",
       "|---|---|\n",
       "| 353874.2 | 19585040 |\n",
       "\n"
      ],
      "text/plain": [
       "  min.oldBal.Orig max.oldBal.Orig\n",
       "1 353874.2        19585040       "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>min.oldBal.Orig</th><th scope=col>max.oldBal.Orig</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>0</td><td>575667.5</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 2\n",
       "\\begin{tabular}{ll}\n",
       " min.oldBal.Orig & max.oldBal.Orig\\\\\n",
       " <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 0 & 575667.5\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 2\n",
       "\n",
       "| min.oldBal.Orig &lt;dbl&gt; | max.oldBal.Orig &lt;dbl&gt; |\n",
       "|---|---|\n",
       "| 0 | 575667.5 |\n",
       "\n"
      ],
      "text/plain": [
       "  min.oldBal.Orig max.oldBal.Orig\n",
       "1 0               575667.5       "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Min, Max of oldBalanceOrig for isFlaggedFraud = 1 TRANSFERs\n",
    "paysim.data %>%\n",
    "    filter(isFlaggedFraud == 1) %>%\n",
    "        summarise(min.oldBal.Orig = min(oldbalanceOrg),\n",
    "                 max.oldBal.Orig = max(oldbalanceOrg))\n",
    "\n",
    "# Min, Max of oldBalanceOrig for isFlaggedFraud = 0 TRANSFERs where oldBalanceOrig = newBalanceOrig\n",
    "paysim.data %>%\n",
    "    filter(type == 'TRANSFER' & isFlaggedFraud == 0\n",
    "          & oldbalanceOrg == newbalanceOrig)%>%\n",
    "            summarise(min.oldBal.Orig = min(oldbalanceOrg),\n",
    "                 max.oldBal.Orig = max(oldbalanceOrg))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d6d6e5ab",
   "metadata": {
    "papermill": {
     "duration": 0.008181,
     "end_time": "2022-11-01T20:10:24.928634",
     "exception": false,
     "start_time": "2022-11-01T20:10:24.920453",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Is it possible to set *isFlaggedFraud* based on observing a consumer making many transactions? It is important to note that duplicate customer names do not exist in transactions where *isFlaggedFraud* is set, but do exist in transactions where it is not. It turns out that users that initiated transactions with the *isFlaggedFraud* flag set have only done so once. Only a small percentage of destination accounts for transactions with the *isFlaggedFraud* flag set have made multiple transactions."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "ece9610c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:24.946406Z",
     "iopub.status.busy": "2022-11-01T20:10:24.945400Z",
     "iopub.status.idle": "2022-11-01T20:10:28.456641Z",
     "shell.execute_reply": "2022-11-01T20:10:28.454768Z"
    },
    "papermill": {
     "duration": 3.522353,
     "end_time": "2022-11-01T20:10:28.458820",
     "exception": false,
     "start_time": "2022-11-01T20:10:24.936467",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "FALSE"
      ],
      "text/latex": [
       "FALSE"
      ],
      "text/markdown": [
       "FALSE"
      ],
      "text/plain": [
       "[1] FALSE"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "FALSE"
      ],
      "text/latex": [
       "FALSE"
      ],
      "text/markdown": [
       "FALSE"
      ],
      "text/plain": [
       "[1] FALSE"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "2"
      ],
      "text/latex": [
       "2"
      ],
      "text/markdown": [
       "2"
      ],
      "text/plain": [
       "[1] 2"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Have originators of transactions flagged as fraud transacted more than once?\n",
    "flagged.transactions <- paysim.data %>%\n",
    "    filter(isFlaggedFraud == 1)\n",
    "\n",
    "not.flagged.transactions <- paysim.data %>%\n",
    "    filter(isFlaggedFraud == 0)\n",
    "\n",
    "any(flagged.transactions$nameOrig %in% not.flagged.transactions$nameOrig || flagged.transactions$nameOrig %in% not.flagged.transactions$nameDest)\n",
    "    \n",
    "# Have destinations for transactions flagged as fraud initiated other transactions?\n",
    "any(flagged.transactions$nameDest %in% not.flagged.transactions$nameOrig)\n",
    "\n",
    "# How many destination accounts of transactions flagged as fraud have been destination accounts more than once?\n",
    "sum(flagged.transactions$nameDest %in% not.flagged.transactions$nameDest)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8288a627",
   "metadata": {
    "papermill": {
     "duration": 0.008741,
     "end_time": "2022-11-01T20:10:28.476140",
     "exception": false,
     "start_time": "2022-11-01T20:10:28.467399",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "It is clear that transactions with the *isFlaggedFraud* flag set happen at all *step* values, just as the complementary set of transactions. As a result, *isFlaggedFraud* does not correlate with *step* either, making it appear that it has no relationship to any explanatory variable or data characteristic."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "22431ad0",
   "metadata": {
    "papermill": {
     "duration": 0.008753,
     "end_time": "2022-11-01T20:10:28.493771",
     "exception": false,
     "start_time": "2022-11-01T20:10:28.485018",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Conclusion: Despite the fact that *isFraud* is always set whenever *isFlaggedFraud* is set, because *isFlaggedFraud* is only set 16 times in a manner that seems meaningless, we may disregard this feature as trivial and remove it from the dataset without losing any data."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7994eb90",
   "metadata": {
    "papermill": {
     "duration": 0.008206,
     "end_time": "2022-11-01T20:10:28.510174",
     "exception": false,
     "start_time": "2022-11-01T20:10:28.501968",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='merchant'></a>\n",
    "##### 2.3. Are expected merchant accounts accordingly labelled?"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "66022f6e",
   "metadata": {
    "papermill": {
     "duration": 0.013974,
     "end_time": "2022-11-01T20:10:28.532326",
     "exception": false,
     "start_time": "2022-11-01T20:10:28.518352",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "According to what was stated <a href='http://www2.bth.se/com/edl.nsf/pages/phd-dissertation'>[5]</a>, CASH IN entails receiving payment from a merchant (whose name begins with a \"M\"). However, as is evident from the chart below, there are no CASH IN transactions between businesses and customers in the current data."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "8d411556",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:28.552052Z",
     "iopub.status.busy": "2022-11-01T20:10:28.550857Z",
     "iopub.status.idle": "2022-11-01T20:10:29.941125Z",
     "shell.execute_reply": "2022-11-01T20:10:29.939853Z"
    },
    "papermill": {
     "duration": 1.401481,
     "end_time": "2022-11-01T20:10:29.942761",
     "exception": false,
     "start_time": "2022-11-01T20:10:28.541280",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>merchants</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " merchants\\\\\n",
       " <lgl>\\\\\n",
       "\\hline\n",
       "\t FALSE\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| merchants &lt;lgl&gt; |\n",
       "|---|\n",
       "| FALSE |\n",
       "\n"
      ],
      "text/plain": [
       "  merchants\n",
       "1 FALSE    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Are there any merchants among originator accounts for CASH_IN transactions?\n",
    "paysim.data %>%\n",
    "    filter(type == 'CASH_IN' & grepl(\"^M\", nameOrig)) %>%\n",
    "    summarise(merchants = any(nameOrig))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "cdd161cc",
   "metadata": {
    "papermill": {
     "duration": 0.008302,
     "end_time": "2022-11-01T20:10:29.959718",
     "exception": false,
     "start_time": "2022-11-01T20:10:29.951416",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "The same way, it was mentioned that CASH OUT entails paying a merchant. There are no merchants among the destination accounts for CASH OUT transactions, nevertheless."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "faf2f88f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:29.978532Z",
     "iopub.status.busy": "2022-11-01T20:10:29.977464Z",
     "iopub.status.idle": "2022-11-01T20:10:32.224594Z",
     "shell.execute_reply": "2022-11-01T20:10:32.223471Z"
    },
    "papermill": {
     "duration": 2.258347,
     "end_time": "2022-11-01T20:10:32.226314",
     "exception": false,
     "start_time": "2022-11-01T20:10:29.967967",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>merchants</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " merchants\\\\\n",
       " <lgl>\\\\\n",
       "\\hline\n",
       "\t FALSE\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| merchants &lt;lgl&gt; |\n",
       "|---|\n",
       "| FALSE |\n",
       "\n"
      ],
      "text/plain": [
       "  merchants\n",
       "1 FALSE    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Are there any merchants among destination accounts for CASH_OUT transactions?\n",
    "paysim.data %>%\n",
    "    filter(type == 'CASH_IN' & grepl(\"^M\", nameDest)) %>%\n",
    "    summarise(merchants = any(nameOrig))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f77c4082",
   "metadata": {
    "papermill": {
     "duration": 0.008495,
     "end_time": "2022-11-01T20:10:32.243970",
     "exception": false,
     "start_time": "2022-11-01T20:10:32.235475",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "In reality, none of the originator accounts include any merchants. For all PAYMENTS, merchants are only visible in destination accounts."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "7cd583ec",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:32.264463Z",
     "iopub.status.busy": "2022-11-01T20:10:32.263254Z",
     "iopub.status.idle": "2022-11-01T20:10:35.327089Z",
     "shell.execute_reply": "2022-11-01T20:10:35.325905Z"
    },
    "papermill": {
     "duration": 3.07636,
     "end_time": "2022-11-01T20:10:35.328738",
     "exception": false,
     "start_time": "2022-11-01T20:10:32.252378",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>merchants</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " merchants\\\\\n",
       " <lgl>\\\\\n",
       "\\hline\n",
       "\t FALSE\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| merchants &lt;lgl&gt; |\n",
       "|---|\n",
       "| FALSE |\n",
       "\n"
      ],
      "text/plain": [
       "  merchants\n",
       "1 FALSE    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>merchants</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " merchants\\\\\n",
       " <lgl>\\\\\n",
       "\\hline\n",
       "\t FALSE\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| merchants &lt;lgl&gt; |\n",
       "|---|\n",
       "| FALSE |\n",
       "\n"
      ],
      "text/plain": [
       "  merchants\n",
       "1 FALSE    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Are there merchants among any originator accounts?\n",
    "paysim.data %>%\n",
    "    filter(grepl(\"^M\", nameOrig)) %>%\n",
    "    summarise(merchants = any(nameOrig))\n",
    "\n",
    "# Are there any transactions having merchants among destination accounts other than the PAYMENT type?\n",
    "paysim.data %>%\n",
    "    filter(type != 'PAYMENT' & grepl(\"^M\", nameDest)) %>%\n",
    "    summarise(merchants = any(nameOrig))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "42c69a56",
   "metadata": {
    "papermill": {
     "duration": 0.008898,
     "end_time": "2022-11-01T20:10:35.346790",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.337892",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "*Conclusion*: For all transactions, the merchant prefix of \"M\" occurs in an unexpected fashion among the account labels \"nameOrig\" and \"nameDest.\""
   ]
  },
  {
   "cell_type": "markdown",
   "id": "61490cdd",
   "metadata": {
    "papermill": {
     "duration": 0.009017,
     "end_time": "2022-11-01T20:10:35.364750",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.355733",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='common-accounts'></a>\n",
    "##### 2.4. Are there account labels common to fraudulent TRANSFERs and CASH_OUTs?"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c59b8a8b",
   "metadata": {
    "papermill": {
     "duration": 0.008795,
     "end_time": "2022-11-01T20:10:35.382510",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.373715",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "According to the data description, the method for committing fraud starts with a TRANSFER to a (fraudulent) account, which is followed by a CASH OUT. CASH OUT includes making a purchase from a business that disburses cash. Therefore, in this two-step operation, the fake account would serve as both the originator and the destination of a TRANSFER and CASH OUT, respectively. The data, however, demonstrates that fraudulent transactions do not share any of these common accounts. The data is not imprinted with the anticipated modus operandi as a result."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "49000fa8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:35.402806Z",
     "iopub.status.busy": "2022-11-01T20:10:35.401631Z",
     "iopub.status.idle": "2022-11-01T20:10:35.414340Z",
     "shell.execute_reply": "2022-11-01T20:10:35.413217Z"
    },
    "papermill": {
     "duration": 0.024557,
     "end_time": "2022-11-01T20:10:35.415931",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.391374",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "FALSE"
      ],
      "text/latex": [
       "FALSE"
      ],
      "text/markdown": [
       "FALSE"
      ],
      "text/plain": [
       "[1] FALSE"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Within fraudulent transactions, are there destinations for TRANSFERS that are also originators for CASH_OUTs?\n",
    "any(fraud.transfer$nameDest %in% fraud.cashout$nameOrig)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "ab4ac9e0",
   "metadata": {
    "papermill": {
     "duration": 0.008801,
     "end_time": "2022-11-01T20:10:35.434035",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.425234",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Could fraudulent TRANSFER destination accounts be the source of undiscovered, genuine-looking CASHOUTs? There are actually 3 of these accounts."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "f7b1b246",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:35.454180Z",
     "iopub.status.busy": "2022-11-01T20:10:35.453044Z",
     "iopub.status.idle": "2022-11-01T20:10:36.528947Z",
     "shell.execute_reply": "2022-11-01T20:10:36.527698Z"
    },
    "papermill": {
     "duration": 1.087719,
     "end_time": "2022-11-01T20:10:36.530537",
     "exception": false,
     "start_time": "2022-11-01T20:10:35.442818",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 3 × 11</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>step</th><th scope=col>type</th><th scope=col>amount</th><th scope=col>nameOrig</th><th scope=col>oldbalanceOrg</th><th scope=col>newbalanceOrig</th><th scope=col>nameDest</th><th scope=col>oldbalanceDest</th><th scope=col>newbalanceDest</th><th scope=col>isFraud</th><th scope=col>isFlaggedFraud</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td> 65</td><td>TRANSFER</td><td>1282971.6</td><td>C1175896731</td><td>1282971.6</td><td>0</td><td>C1714931087</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>\n",
       "\t<tr><td>486</td><td>TRANSFER</td><td> 214793.3</td><td>C2140495649</td><td> 214793.3</td><td>0</td><td>C423543548 </td><td>0</td><td>0</td><td>1</td><td>0</td></tr>\n",
       "\t<tr><td>738</td><td>TRANSFER</td><td> 814689.9</td><td>C2029041842</td><td> 814689.9</td><td>0</td><td>C1023330867</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 3 × 11\n",
       "\\begin{tabular}{lllllllllll}\n",
       " step & type & amount & nameOrig & oldbalanceOrg & newbalanceOrig & nameDest & oldbalanceDest & newbalanceDest & isFraud & isFlaggedFraud\\\\\n",
       " <int> & <chr> & <dbl> & <chr> & <dbl> & <dbl> & <chr> & <dbl> & <dbl> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t  65 & TRANSFER & 1282971.6 & C1175896731 & 1282971.6 & 0 & C1714931087 & 0 & 0 & 1 & 0\\\\\n",
       "\t 486 & TRANSFER &  214793.3 & C2140495649 &  214793.3 & 0 & C423543548  & 0 & 0 & 1 & 0\\\\\n",
       "\t 738 & TRANSFER &  814689.9 & C2029041842 &  814689.9 & 0 & C1023330867 & 0 & 0 & 1 & 0\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 3 × 11\n",
       "\n",
       "| step &lt;int&gt; | type &lt;chr&gt; | amount &lt;dbl&gt; | nameOrig &lt;chr&gt; | oldbalanceOrg &lt;dbl&gt; | newbalanceOrig &lt;dbl&gt; | nameDest &lt;chr&gt; | oldbalanceDest &lt;dbl&gt; | newbalanceDest &lt;dbl&gt; | isFraud &lt;int&gt; | isFlaggedFraud &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|\n",
       "|  65 | TRANSFER | 1282971.6 | C1175896731 | 1282971.6 | 0 | C1714931087 | 0 | 0 | 1 | 0 |\n",
       "| 486 | TRANSFER |  214793.3 | C2140495649 |  214793.3 | 0 | C423543548  | 0 | 0 | 1 | 0 |\n",
       "| 738 | TRANSFER |  814689.9 | C2029041842 |  814689.9 | 0 | C1023330867 | 0 | 0 | 1 | 0 |\n",
       "\n"
      ],
      "text/plain": [
       "  step type     amount    nameOrig    oldbalanceOrg newbalanceOrig nameDest   \n",
       "1  65  TRANSFER 1282971.6 C1175896731 1282971.6     0              C1714931087\n",
       "2 486  TRANSFER  214793.3 C2140495649  214793.3     0              C423543548 \n",
       "3 738  TRANSFER  814689.9 C2029041842  814689.9     0              C1023330867\n",
       "  oldbalanceDest newbalanceDest isFraud isFlaggedFraud\n",
       "1 0              0              1       0             \n",
       "2 0              0              1       0             \n",
       "3 0              0              1       0             "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Fraudulent TRANSFERs whose destination accounts are originators of genuine CASH_OUTs\n",
    "no.fraud.cashout <- not.flagged.transactions %>%\n",
    "    filter(type == 'CASH_OUT')\n",
    "\n",
    "fraud.transfer %>%\n",
    "    filter(nameDest %in% no.fraud.cashout$nameOrig)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "dfd1a58d",
   "metadata": {
    "papermill": {
     "duration": 0.009003,
     "end_time": "2022-11-01T20:10:36.549028",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.540025",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "But in 2 out of 3 of these accounts, a legitimate CASH OUT occurs first, and only then (as shown by the time step) does a fraudulent TRANSFER occur. The nameOrig and nameDest features so do not flag fraudulent transactions."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "91f4329d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:36.569301Z",
     "iopub.status.busy": "2022-11-01T20:10:36.568186Z",
     "iopub.status.idle": "2022-11-01T20:10:36.658185Z",
     "shell.execute_reply": "2022-11-01T20:10:36.657002Z"
    },
    "papermill": {
     "duration": 0.102355,
     "end_time": "2022-11-01T20:10:36.660356",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.558001",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>step</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>185</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " step\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 185\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| step &lt;int&gt; |\n",
       "|---|\n",
       "| 185 |\n",
       "\n"
      ],
      "text/plain": [
       "  step\n",
       "1 185 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Fraudulent TRANSFER to C423543548 occured at step = 486 whereas genuine CASH_OUT from this account occured earlier at step\n",
    "no.fraud.cashout %>%\n",
    "    filter(nameOrig == 'C423543548')%>%\n",
    "    select(step)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "5e7a093a",
   "metadata": {
    "papermill": {
     "duration": 0.009349,
     "end_time": "2022-11-01T20:10:36.679649",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.670300",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "*Conclusion*: Given that the *nameOrig* and *nameDest* features do not encode merchant accounts in the manner that is intended according to  section <a href='#merchant'>2.3</a> above, below we discuss this.\n",
    "\n",
    "Discard these features from the data because they have no purpose."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "4b1ee742",
   "metadata": {
    "papermill": {
     "duration": 0.009025,
     "end_time": "2022-11-01T20:10:36.697759",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.688734",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='clean'></a>\n",
    "#### 3. Data cleaning"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "5a31a516",
   "metadata": {
    "papermill": {
     "duration": 0.009077,
     "end_time": "2022-11-01T20:10:36.715909",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.706832",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "We can conclude from the exploratory data analysis (EDA) in section <a href='#EDA#'>2</a> that fraud only affects \"TRANSFER\" and \"CASH OUT\" transactions. Therefore, we merely compile the pertinent data from X for analysis."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "da659971",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:36.736897Z",
     "iopub.status.busy": "2022-11-01T20:10:36.735619Z",
     "iopub.status.idle": "2022-11-01T20:10:40.635774Z",
     "shell.execute_reply": "2022-11-01T20:10:40.634630Z"
    },
    "papermill": {
     "duration": 3.912774,
     "end_time": "2022-11-01T20:10:40.637904",
     "exception": false,
     "start_time": "2022-11-01T20:10:36.725130",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>isFraud</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>0</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>0</td></tr>\n",
       "\t<tr><th scope=row>5</th><td>0</td></tr>\n",
       "\t<tr><th scope=row>6</th><td>0</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 1\n",
       "\\begin{tabular}{r|l}\n",
       "  & isFraud\\\\\n",
       "  & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1\\\\\n",
       "\t2 & 1\\\\\n",
       "\t3 & 0\\\\\n",
       "\t4 & 0\\\\\n",
       "\t5 & 0\\\\\n",
       "\t6 & 0\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 1\n",
       "\n",
       "| <!--/--> | isFraud &lt;int&gt; |\n",
       "|---|---|\n",
       "| 1 | 1 |\n",
       "| 2 | 1 |\n",
       "| 3 | 0 |\n",
       "| 4 | 0 |\n",
       "| 5 | 0 |\n",
       "| 6 | 0 |\n",
       "\n"
      ],
      "text/plain": [
       "  isFraud\n",
       "1 1      \n",
       "2 1      \n",
       "3 0      \n",
       "4 0      \n",
       "5 0      \n",
       "6 0      "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 8</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>step</th><th scope=col>type</th><th scope=col>amount</th><th scope=col>oldbalanceOrg</th><th scope=col>newbalanceOrig</th><th scope=col>oldbalanceDest</th><th scope=col>newbalanceDest</th><th scope=col>isFraud</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1</td><td>TRANSFER</td><td>   181.0</td><td>  181.00</td><td>0</td><td>     0</td><td>      0.00</td><td>1</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1</td><td>CASH_OUT</td><td>   181.0</td><td>  181.00</td><td>0</td><td> 21182</td><td>      0.00</td><td>1</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1</td><td>CASH_OUT</td><td>229133.9</td><td>15325.00</td><td>0</td><td>  5083</td><td>  51513.44</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>1</td><td>TRANSFER</td><td>215310.3</td><td>  705.00</td><td>0</td><td> 22425</td><td>      0.00</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>5</th><td>1</td><td>TRANSFER</td><td>311685.9</td><td>10835.00</td><td>0</td><td>  6267</td><td>2719172.89</td><td>0</td></tr>\n",
       "\t<tr><th scope=row>6</th><td>1</td><td>CASH_OUT</td><td>110414.7</td><td>26845.41</td><td>0</td><td>288800</td><td>   2415.16</td><td>0</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 8\n",
       "\\begin{tabular}{r|llllllll}\n",
       "  & step & type & amount & oldbalanceOrg & newbalanceOrig & oldbalanceDest & newbalanceDest & isFraud\\\\\n",
       "  & <int> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1 & TRANSFER &    181.0 &   181.00 & 0 &      0 &       0.00 & 1\\\\\n",
       "\t2 & 1 & CASH\\_OUT &    181.0 &   181.00 & 0 &  21182 &       0.00 & 1\\\\\n",
       "\t3 & 1 & CASH\\_OUT & 229133.9 & 15325.00 & 0 &   5083 &   51513.44 & 0\\\\\n",
       "\t4 & 1 & TRANSFER & 215310.3 &   705.00 & 0 &  22425 &       0.00 & 0\\\\\n",
       "\t5 & 1 & TRANSFER & 311685.9 & 10835.00 & 0 &   6267 & 2719172.89 & 0\\\\\n",
       "\t6 & 1 & CASH\\_OUT & 110414.7 & 26845.41 & 0 & 288800 &    2415.16 & 0\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 8\n",
       "\n",
       "| <!--/--> | step &lt;int&gt; | type &lt;chr&gt; | amount &lt;dbl&gt; | oldbalanceOrg &lt;dbl&gt; | newbalanceOrig &lt;dbl&gt; | oldbalanceDest &lt;dbl&gt; | newbalanceDest &lt;dbl&gt; | isFraud &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | 1 | TRANSFER |    181.0 |   181.00 | 0 |      0 |       0.00 | 1 |\n",
       "| 2 | 1 | CASH_OUT |    181.0 |   181.00 | 0 |  21182 |       0.00 | 1 |\n",
       "| 3 | 1 | CASH_OUT | 229133.9 | 15325.00 | 0 |   5083 |   51513.44 | 0 |\n",
       "| 4 | 1 | TRANSFER | 215310.3 |   705.00 | 0 |  22425 |       0.00 | 0 |\n",
       "| 5 | 1 | TRANSFER | 311685.9 | 10835.00 | 0 |   6267 | 2719172.89 | 0 |\n",
       "| 6 | 1 | CASH_OUT | 110414.7 | 26845.41 | 0 | 288800 |    2415.16 | 0 |\n",
       "\n"
      ],
      "text/plain": [
       "  step type     amount   oldbalanceOrg newbalanceOrig oldbalanceDest\n",
       "1 1    TRANSFER    181.0   181.00      0                   0        \n",
       "2 1    CASH_OUT    181.0   181.00      0               21182        \n",
       "3 1    CASH_OUT 229133.9 15325.00      0                5083        \n",
       "4 1    TRANSFER 215310.3   705.00      0               22425        \n",
       "5 1    TRANSFER 311685.9 10835.00      0                6267        \n",
       "6 1    CASH_OUT 110414.7 26845.41      0              288800        \n",
       "  newbalanceDest isFraud\n",
       "1       0.00     1      \n",
       "2       0.00     1      \n",
       "3   51513.44     0      \n",
       "4       0.00     0      \n",
       "5 2719172.89     0      \n",
       "6    2415.16     0      "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "X = paysim.data %>%\n",
    "    filter(type == 'TRANSFER' | type == 'CASH_OUT')\n",
    "\n",
    "set.seed(5)\n",
    "\n",
    "Y = X %>%select('isFraud')\n",
    "head(Y)\n",
    "# Eliminate columns shown to be irrelevant for analysis in the EDA\n",
    "X <- X %>%\n",
    "    select(-c('nameOrig', 'nameDest', 'isFlaggedFraud'))\n",
    "head(X)\n",
    "# Binary Encoding of labelled data\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "81a3575e",
   "metadata": {
    "papermill": {
     "duration": 0.009377,
     "end_time": "2022-11-01T20:10:40.657232",
     "exception": false,
     "start_time": "2022-11-01T20:10:40.647855",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "<a id='imputation'></a>\n",
    "##### 3.1. Imputation of Latent Missing Values"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7acb584e",
   "metadata": {
    "papermill": {
     "duration": 0.009317,
     "end_time": "2022-11-01T20:10:40.675746",
     "exception": false,
     "start_time": "2022-11-01T20:10:40.666429",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "The data contains a number of transactions where the destination account's balance is zero, both before and after a transaction involving a non-zero amount. The proportion of these transactions where the value is most likely missing is significantly higher in fraudulent transactions (50%) compared to genuine transactions (0.06%)."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "7548c39c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-01T20:10:40.697551Z",
     "iopub.status.busy": "2022-11-01T20:10:40.696335Z",
     "iopub.status.idle": "2022-11-01T20:10:40.808149Z",
     "shell.execute_reply": "2022-11-01T20:10:40.806718Z"
    },
    "papermill": {
     "duration": 0.124995,
     "end_time": "2022-11-01T20:10:40.810459",
     "exception": false,
     "start_time": "2022-11-01T20:10:40.685464",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "Xfraud = X %>%\n",
    "    filter(Y == 1)\n",
    "\n",
    "Xnonfraud = X %>%\n",
    "    filter(Y == 0)\n",
    "# The fraction of fraudulent transactions with 'oldBalanceDest' = 'newBalanceDest' = 0 although the transacted 'amount' is non-zero is:\n",
    "# The fraction of genuine transactions with 'oldBalanceDest' = 'newBalanceDest' = 0 although the transacted 'amount' is non-zero is"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 136.60896,
   "end_time": "2022-11-01T20:10:41.039564",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-01T20:08:24.430604",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
