# TrafficBDEWrapper
A wrapper for the TrafficBDE package (https://github.com/ptzenos/TrafficBDE)

Gets the latest train dataset, it trains the models and returns a data frame with the predictions.

Example run:
library(TrafficBDE)
GetPrediction(1,1)

To run concurrently in 2 different sessions, you can run the following in each session:
(In session 1): GetPrediction(1,2) 
(In session 2): GetPrediction(2,2) 

For 3 different sessions:
(In session 1): GetPrediction(1,3) 
(In session 2): GetPrediction(2,3) 
(In session 3): GetPrediction(3,3) 
